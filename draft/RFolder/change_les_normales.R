
# CHANGE THE PATH
#setwd("C:/Users/rems9/OneDrive - GENES/Bureau/Etudes/ENSAE/3A/bayesian_statistics/projet_bayesian") 

setwd("/Users/augustincablant/Documents/GitHub/Bayesian-Statistics")
# Install necessary packages

#install.packages("devtools")
library(devtools)
#devtools::install_github("sarawade/mcclust.ext")
#install.packages("dirichletprocess")
#install.packages("ggplot2") # For visualization
library(ggplot2)
library(dirichletprocess)
library(mcclust.ext)

set.seed(123)

# Parameters for the mixture model
n <- 200 # Total number of samples
mu <- list(c(-1, -1), c(1, -1), c(-1, 1), c(1, 1)) # Clusters are closer than in the other example replaces all the 2 by 1
sigma <- list(diag(c(1, 1)), diag(c(1, 1)), diag(c(1, 1)), diag(c(1, 1))) # Identity for all (same as example 1 in the article)
n_clusters <- length(mu)

# Generate our mixture of 4 Gaussians defined above
data <- do.call(rbind, lapply(1:n_clusters, function(i) {
  mvtnorm::rmvnorm(n / n_clusters, mean = mu[[i]], sigma = sigma[[i]])
}))


# Get true labels
true_labels <- unlist(lapply(1:n_clusters, function(i) {
  rep(i, n / n_clusters)
}))


# Create a dataframe that contains the 2 coordinates of each point in the first and second column and
# their cluster's true label in the third column 
df <- as.data.frame(data)
colnames(df) <- c("X1", "X2")
df$true_cluster <- as.factor(true_labels)


# Initialize Dirichlet Process, put a Gam(1,1) hyperprior on alpha as in the article
dp <- DirichletProcessMvnormal(
  y = data,
  alphaPriors = c(1, 1),
  numInitialClusters = 1
)



# You can uncomment the following lines if you want but it takes a long time to run 
#so you can just import the already ran result stored in a file.
# Fit the model (10000 iterations)
#dp <- Fit(dp, its = 10000)   

# Save the fitted Dirichlet Process object
#saveRDS(dp, file = "dp_model10000_bien_closer.rds")

# Load the saved Dirichlet Process object to run the script faster. Comment next line if you uncommented lines above
dp <- readRDS("RFolder/dp_model10000_bien_closer.rds")

# Burn in 1000 iterations
burn_in <- 1000  # Number of iterations to discard
dp_samples <- dp$posteriorParams[-(1:burn_in)]



# Extract posterior cluster assignments
posterior_draws <- do.call(rbind, dp$labelsChain)

# Burn in
posterior_draws_burned <- posterior_draws[-(1:burn_in), ]

# Check the dimensions
print(dim(posterior_draws_burned))

# Compute the pairwise similarity matrix
psm <- comp.psm(posterior_draws_burned)




########## HERE WE DO VI, WE WILL DO BINDER AFTER

# Find the representative partition using minVI
vi_partition <- minVI(psm, posterior_draws_burned, method = "all", include.greedy = TRUE)
summary(vi_partition)

# Extract the greedy clustering labels from vi_partition$cl
final_clusters <- vi_partition$cl["greedy", ]

# Add the final clustering labels to the data frame
df$vi_cluster <- as.factor(final_clusters)

# Visualize the clustering results
library(ggplot2)
ggplot(df, aes(x = X1, y = X2, color = vi_cluster)) +
  geom_point() +
  labs(title = "Representative Clustering (VI) (Greedy)") +
  theme_minimal()




# Compute the credible ball for the clustering
credible_ball <- credibleball(vi_partition$cl["greedy", ], posterior_draws_burned)

# View the summary of the credible ball
summary(credible_ball)

# Plot the credible ball
plot(credible_ball, data = df[, c("X1", "X2")])






####### Ca c'est pas encore bon



# Compute cluster means and covariances for ellipses
ellipses_data <- lapply(unique(final_clusters), function(cluster) {
  cluster_data <- df[df$vi_cluster == cluster, c("X1", "X2")]
  list(
    mean = colMeans(cluster_data),
    cov = cov(cluster_data),
    cluster = cluster
  )
})

# Create a function to generate ellipse points
generate_ellipse <- function(mean, cov, cluster, n = 100) {
  theta <- seq(0, 2 * pi, length.out = n)
  circle <- cbind(cos(theta), sin(theta))
  ellipse <- t(chol(cov)) %*% t(circle) + mean
  data.frame(X1 = ellipse[1, ], X2 = ellipse[2, ], cluster = cluster)
}

# Combine ellipses into a single data frame
ellipses_df <- do.call(rbind, lapply(ellipses_data, function(params) {
  generate_ellipse(params$mean, params$cov, params$cluster)
}))

# Plot the data with ellipses
ggplot(df, aes(x = X1, y = X2, color = vi_cluster)) +
  geom_point() +
  geom_path(data = ellipses_df, aes(x = X1, y = X2, group = cluster, color = as.factor(cluster)), size = 1) +
  labs(title = "Clustering Results", color = "Cluster") +
  theme_minimal()








######### NOW WE DO WITH BINDER'S LOSS INSTEAD OF VI 


# Find the representative partition using minVI
binder_partition <- minbinder.ext(psm, posterior_draws_burned, method = "all", include.greedy = TRUE)
summary(binder_partition)

# Extract the greedy clustering labels from vi_partition$cl
final_clusters <- binder_partition$cl["greedy", ]

# Add the final clustering labels to the data frame
df$binder_cluster <- as.factor(final_clusters)

# Visualize the clustering results
library(ggplot2)
ggplot(df, aes(x = X1, y = X2, color = binder_cluster)) +
  geom_point() +
  labs(title = "Representative Clustering (Binder's loss) (Greedy)") +
  theme_minimal()




# Compute the credible ball for the clustering
credible_ball_binder <- credibleball(binder_partition$cl["greedy", ], posterior_draws_burned, c.dist = "Binder")

# View the summary of the credible ball
summary(credible_ball)

# Plot the credible ball
plot(credible_ball_binder, data = df[, c("X1", "X2")])



#### Si on veut 

# Optional: Ellipses for Binder's loss clustering
ellipses_data <- lapply(unique(final_clusters), function(cluster) {
  cluster_data <- df[df$binder_cluster == cluster, c("X1", "X2")]
  list(
    mean = colMeans(cluster_data),
    cov = cov(cluster_data),
    cluster = cluster
  )
})

generate_ellipse <- function(mean, cov, cluster, n = 100) {
  theta <- seq(0, 2 * pi, length.out = n)
  circle <- cbind(cos(theta), sin(theta))
  ellipse <- t(chol(cov)) %*% t(circle) + mean
  data.frame(X1 = ellipse[1, ], X2 = ellipse[2, ], cluster = cluster)
}

ellipses_df <- do.call(rbind, lapply(ellipses_data, function(params) {
  generate_ellipse(params$mean, params$cov, params$cluster)
}))

ggplot(df, aes(x = X1, y = X2, color = binder_cluster)) +
  geom_point() +
  geom_path(data = ellipses_df, aes(x = X1, y = X2, group = cluster, color = as.factor(cluster)), size = 1) +
  labs(title = "Clustering Results with Credible Ellipses (Binder's Loss)", color = "Cluster") +
  theme_minimal()
