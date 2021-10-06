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
}

// yi = b0 + b1xi1 + ei
// ei ~ N(0, sigma)
// yi ~ N(b0 + b1xi1, sigma) <- This is the modle


// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real<lower=0> sigma;
  real b0;
  real b1a;
  real b1b;
}

transformed parameters {
  real b1;
  b1=b1a+b1b;
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  y ~ normal(b0 + (b1a+b1b)*pretest_MC
, sigma);
}
