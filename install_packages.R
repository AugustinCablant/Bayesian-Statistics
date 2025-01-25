packages <- c(
  "ggplot2", 
  "devtools", 
  "dirichletprocess"
)

install.packages(setdiff(packages, rownames(installed.packages())))

devtools::install_github("sarawade/mcclust.ext")