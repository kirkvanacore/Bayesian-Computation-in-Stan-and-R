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
// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> N;
  vector[N] y;
  vector[N] pretest_MC;
  vector[N] FH2T;
  vector[N] Dragon;
  vector[N] ASSISTments;
}

parameters {
  real<lower=0> sigma;
  real b0;
  real b1a;
  real b1b;
  real b2;
  real b3;
  real b4;
}

transformed parameters {
  real b1;
  b1=b1a+b1b;
}

//Y=b0+(b1a+b1b)*pretest+b2*FH2T + b3*Dragon+ b4*ASSISTments+epsilon

model {
  y ~ normal(b0 + (b1a+b1b)*pretest_MC + b2*FH2T + b3*Dragon + b4*ASSISTments
, sigma);
}

