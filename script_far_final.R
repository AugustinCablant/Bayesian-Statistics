
# CHANGE THE PATH
setwd("C:/Users/rems9/OneDrive - GENES/Bureau/Etudes/ENSAE/3A/bayesian_statistics/projet_bayesian") 

# Install necessary packages

install.packages("devtools")
library(devtools)
devtools::install_github("sarawade/mcclust.ext")
install.packages("dirichletprocess")
install.packages("ggplot2") # For visualization
library(ggplot2)
library(dirichletprocess)
library(mcclust.ext)
install.packages("salso")
library("salso")

set.seed(123)



# Parameters for the mixture model
n <- 200 # Total number of samples
mu <- list(c(-2, -2), c(2, -2), c(-2, 2), c(2, 2)) 
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


# Plot true clusters
ggplot(df, aes(x = X1, y = X2, color = true_cluster)) +
  geom_point() +
  labs(title = "True partition") +
  theme_minimal()



# Initialize Dirichlet Process, put a Gam(1,1) hyperprior on alpha as in the article
dp <- DirichletProcessMvnormal(
  y = data,
  alphaPriors = c(1, 1),
  numInitialClusters = 1
)

# Fit the model (10000 iterations), it takes a lot of time
dp <- Fit(dp, its = 10000) 

# Save the fitted Dirichlet Process object in case we want to reuse it
saveRDS(dp, file = "dp_model_far_good.rds")


# Burn in 1000 iterations
burn_in <- 1000  # Number of iterations to discard
dp_samples <- dp$posteriorParams[-(1:burn_in)]

# Extract posterior cluster assignments
posterior_draws <- do.call(rbind, dp$labelsChain)

# Burn in
posterior_draws_burned <- posterior_draws[-(1:burn_in), ]

# Compute the psm
psm <- comp.psm(posterior_draws_burned)







########## HERE WE START DOING ANALYSIS FOR VI POINT ESTIMATE, WE WILL DO BINDER'S AFTER

# Find the representative partition using minVI
vi_partition <- minVI(psm, posterior_draws_burned, method = "all", include.greedy = TRUE)
summary(vi_partition)

# Extract the greedy clustering labels from vi_partition$cl
final_clusters <- vi_partition$cl["greedy", ]

# Add the final clustering labels to the data frame
df$vi_cluster <- as.factor(final_clusters)

# VI distance for VI point estimate 
partition.loss(df$true_cluster, df$vi_cluster, loss = VI())

# Binder's distance for VI point estimate
partition.loss(df$true_cluster, df$vi_cluster, loss = binder())
# missclassification
print(sum(df$true_cluster != df$vi_cluster))


# Plot of clustering results for VI point estimate
ggplot(df, aes(x = X1, y = X2, color = vi_cluster)) +
  geom_point() +
  labs(title = "Representative Clustering (VI) (Greedy)") +
  theme_minimal()

# Computation of the credibleball 
credible_ball <- credibleball(vi_partition$cl["greedy", ], posterior_draws_burned)
summary(credible_ball)

# Plot credible balls "bounds"
plot(credible_ball, data = df[, c("X1", "X2")])





######### NOW WE DO THE ANALYSIS WITH BINDER'S LOSS POINT ESTIMATE INSTEAD OF VI 

# Find the representative partition
binder_partition <- minbinder.ext(psm, posterior_draws_burned, method = "all", include.greedy = TRUE)
summary(binder_partition)


# Extract the greedy clustering labels from binder_partition$cl
final_clusters <- binder_partition$cl["greedy", ]

# Add binder clustering labels to the data frame
df$binder_cluster <- as.factor(final_clusters)


# Compute VI distance of Binder's point estimate
partition.loss(df$true_cluster, df$binder_cluster, loss = VI())

# Compute Binder's distance of Binder's point estimate
partition.loss(df$true_cluster, df$binder_cluster, loss = binder())

# Compute Expected Binder's loss of posterior for binder's and VI point estimates
mean(partition.loss(df$binder_cluster, posterior_draws_burned, loss = binder()))
mean(partition.loss(df$vi_cluster, posterior_draws_burned, loss = binder()))

# Compute Expected VI loss of posterior for binder's and VI point estimates
mean(partition.loss(df$binder_cluster, posterior_draws_burned, loss = VI()))
mean(partition.loss(df$vi_cluster, posterior_draws_burned, loss = VI()))

# number missclassification
print(sum(as.character(df$true_cluster) != as.character(df$binder_cluster)))


# Plot the clustering results for Binder's point estimate
ggplot(df, aes(x = X1, y = X2, color = binder_cluster)) +
  geom_point() +
  labs(title = "Representative Clustering (Binder's loss) (Greedy)") +
  theme_minimal()


# Computation of the credible ball 
credible_ball_binder <- credibleball(binder_partition$cl["greedy", ], posterior_draws_burned, c.dist = "Binder")
# credible ball "bounds"
summary(credible_ball_binder)

# Plot the credible ball "bounds"
plot(credible_ball_binder, data = df[, c("X1", "X2")])




