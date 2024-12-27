# Bayesian Cluster Analysis: Point Estimation and Credible Balls  

## Project Overview  
This project applies Bayesian cluster analysis, inspired by the methodology presented in the paper *"Bayesian cluster analysis: Point estimation and credible balls"*. The objective is to analyze a clustering problem using Bayesian techniques, with real or simulated data, to understand uncertainty in cluster assignments while leveraging advanced statistical methods.  

## Project Goals  
1. **Define the Problem**: Clearly outline the clustering problem and its significance.  
2. **Apply Bayesian Techniques**: Use appropriate Bayesian methods seen in class to analyze the problem.  
3. **Methodology Explanation**: Explain the Bayesian technique selected, its motivation, and its relation to the problem.  
4. **Computational Implementation**: Describe the computational methods used and challenges encountered.  
5. **Interpret the Results**: Present and interpret the findings, comparing them to results obtained via a frequentist approach.  

## Key Features  
- **Data**: Analysis using either a real-world dataset or simulated data.  
- **Methodology**: Exploration of Bayesian techniques such as posterior distributions, point estimation, and credible intervals (credible balls).  
- **Comparison**: Evaluate and contrast Bayesian and frequentist results.  

## Project Structure  

1. **Problem Statement**:  
   - Introduction to the clustering problem.  
   - Explanation of the importance and relevance of the chosen dataset or simulation setup.  

2. **Bayesian Methodology**:  
   - Overview of the Bayesian cluster analysis approach.  
   - Justification for choosing Bayesian methods over other approaches.  
   - Explanation of point estimation and credible balls in clustering contexts.  

3. **Computational Implementation**:  
   - Description of algorithms used (e.g., MCMC, variational inference, etc.).  
   - Discussion of challenges (e.g., convergence issues, computational complexity).  

4. **Results and Interpretation**:  
   - Presentation of clustering results.  
   - Interpretation of the posterior distribution and credible intervals.  
   - Comparison with frequentist clustering methods (e.g., k-means, hierarchical clustering).  

5. **Conclusion**:  
   - Summary of findings.  
   - Insights into the strengths and limitations of the Bayesian approach.  

## Deliverables  
- **Final Report**: A detailed document covering the problem definition, methodology, computational details, results, and comparisons.  
- **Codebase**: A fully reproducible set of scripts in Python/R for data analysis and visualization.  
- **Due Date**: January 25th, 2025.  

## Getting Started  

### Prerequisites  
- Knowledge of Bayesian methods (as covered in class).  
- Tools: Python (PyMC3/NumPyro/Stan) or R (rstan/Bayesian packages).  

### Installation  
Clone this repository and install dependencies:  
```bash  
git clone <repository_link>  
cd <project_folder>  
pip install -r requirements.txt  
```

## Run the Code
- Access datasets or generate simulations.
- Execute scripts for Bayesian cluster analysis.

## Authors and Contributions

Team Members: Théo Moret, Rémi ?, Augustin Cablant
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


