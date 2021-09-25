//
// This Stan program defines a simple model, with a
// vector of values 'y' modeled as normally distributed
// with mean 'mu' and standard deviation 'sigma'.
//
// Learn more about model development with Stan at:
//
//    http://mc-stan.org/users/interfaces/rstan.html
//    https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started
//

// Declare Data that wil be passed to stan from r
data {
  int<lower=0> J;         // number of schools 
  real y[J];              // estimated treatment effects
  real<lower=0> sigma[J]; // standard error of effect estimates 
}

//int -> number is intiger
//real -> rela number
//real<lower=0> -> real number that is not negive lower limit spepecified

parameters {
  real mu;                // population treatment effect - (the mean treatment effect) 
  real<lower=0> tau;      // standard deviation in treatment effects - (the SD)
  vector[J] eta;          // unscaled deviation from mu by school (the residual)
}
transformed parameters {
  vector[J] theta = mu + tau * eta;        // school treatment effects
}
model {
  target += normal_lpdf(eta | 0, 1);       // prior log-density
  target += normal_lpdf(y | theta, sigma); // log-likelihood
}
