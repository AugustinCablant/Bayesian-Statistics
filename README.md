# Bayesian Cluster Analysis: Point Estimation and Credible Balls  

## Project Overview  
This project applies Bayesian cluster analysis, inspired by the methodology presented in the paper *"Bayesian cluster analysis: Point estimation and credible balls"*. The objective is to analyze a clustering problem using Bayesian techniques, with real or simulated data, to understand uncertainty in cluster assignments while leveraging advanced statistical methods.  



## Deliverables  
- **Final Report**: A detailed document covering the problem definition, methodology, computational details, results, and comparisons.  
- **Codebase**: A fully reproducible set of scripts in Python/R for data analysis and visualization.  
- **Due Date**: January 25th, 2025.  

## Getting Started  

### Prerequisites  
- Knowledge of Bayesian methods (as covered in class).  
- Tools: R. 

### Installation  
Clone this repository and install dependencies:  
```bash  
git clone <repository_link>  
cd <project_folder>  
```

## Run the Code
- Set your path at the begining of the two scripts
- Note that each file takes approximatively 40 mins to run depending on your computing power.
- Start by executing the script script_far_final.R. It contains the code to produce statistics and plots for a mixture of gaussians.
- Then you can run the script script_close_final.R expect the last 2 lines that should not be ran before analyzing the results produced by the rest of the code because it will make the console unreadable. This file contains the code to produce statistics for an other mixture of gaussians that are closer than in the file script_far_final.R.


## Authors and Contributions

Team Members: Théo Moret, Rémi Calvet, Augustin Cablant
Instructor: Anna Simoni 

## References  

- Hennig, C., & Coretto, P. (2022). *Bayesian cluster analysis: Point estimation and credible balls*. Journal of the Royal Statistical Society: Series B.  
  - This paper introduces a novel approach to Bayesian cluster analysis, focusing on point estimation and credible balls to quantify uncertainty in clustering.  

- Class Materials:  
  - Lecture notes and examples on Bayesian inference, posterior distributions, and computational methods such as MCMC and variational inference.  

- Gelman, A., Carlin, J. B., Stern, H. S., Dunson, D. B., Vehtari, A., & Rubin, D. B. (2013). *Bayesian Data Analysis* (3rd ed.). CRC Press.  
  - A comprehensive resource on Bayesian methods, covering theoretical foundations and practical applications.  

- McElreath, R. (2020). *Statistical Rethinking: A Bayesian Course with Examples in R and Stan* (2nd ed.). CRC Press.  
  - A user-friendly introduction to Bayesian data analysis with real-world examples and code.  

- Carpenter, B., Gelman, A., Hoffman, M. D., Lee, D., Goodrich, B., Betancourt, M., & Riddell, A. (2017). *Stan: A Probabilistic Programming Language*. Journal of Statistical Software.  
  - A foundational tool for Bayesian computation used extensively in this project.  


