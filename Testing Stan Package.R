#### How to Use RStan ####

#The rest of this document assumes that you have already
# installed RStan by following the instructions above.
#
# Loading the package The package name is rstan (all lowercase), so we start by
# executing

library("rstan") # observe startup messages

# unexpected WARNINGS: 
# Warning messages:
#   1: In normalizePath(dirname(f)) : path[1]="NA": No such file or directory
# 2: In as.POSIXlt.POSIXct(Sys.time()) :
#   unknown timezone 'zone/tz/2021a.1.0/zoneinfo/America/New_York'

#As the startup message says, if you are using rstan locally on a multicore
#machine and have plenty of RAM to estimate your model in parallel, at this
#point execute

options(mc.cores = parallel::detectCores())

# In addition, you should follow the second startup message that says to execute
#


rstan_options(auto_write = TRUE)
#
# which allows you to automatically save a bare version of a compiled Stan
# program to the hard disk so that it does not need to be recompiled (unless you
# change it). You will need to run these commands each time you load the rstan
# library.
#
# Finally, if you use Windows, there will be a third startup message saying not
# to use --march=native compiler flag. You can ignore this warning if you
# followed the steps above and your Makevars.win file does not contain this
# flag.
#
# Example 1: Eight Schools This is an example in Section 5.5 of Gelman et al
# (2003), which studied coaching effects from eight schools. For simplicity, we
# call this example "eight schools."
#
# We start by writing a Stan program for the model in a text file. If you are
# using RStudio version 1.2.x or greater, click on File -> New File -> Stan File
# . Otherwise, open your favorite text editor. Either way, paste in the
# following and save your work to a file called schools.stan in R's working
# directory (which can be seen by executing getwd())

### Saved Stan File

# Be sure that your Stan programs ends in a blank line without any characters
# including spaces and comments.

# In this Stan program, we let theta be a transformation of mu, eta, and tau
# instead of declaring theta in the parameters block, which allows the sampler
# will run more efficiently (see detailed explanation). We can prepare the data
# (which typically is a named list) in R with:

schools_dat <- list(J = 8, 
                    y = c(28,  8, -3,  7, -1,  1, 18, 12),
                    sigma = c(15, 10, 16, 11,  9, 11, 10, 18))

# And we can get a fit with the following R command. Note that the argument to
# file = should point to where the file is on your file system unless you have
# put it in the working directory of R in which case the below will work.

fit <- stan(file = 'schools.stan', data = schools_dat)

####unexpected WARNINGS: 
  # Warning messages:
  #   1: In normalizePath(dirname(f)) : path[1]="NA": No such file or directory
  # 2: In as.POSIXlt.POSIXct(Sys.time()) :
  #   unknown timezone 'zone/tz/2021a.1.0/zoneinfo/America/New_York'

# solutaion: Change Delta

fit <- stan(file = 'schools.stan', 
            data = schools_dat,
            control = list(adapt_delta = 0.99))

#The object fit, returned from function stan is an S4 object of class stanfit.
#On Windows you may get a warning about g++ not being found but this appears to
#be harmless. Methods such as print, plot, and pairs are associated with the
#fitted result so we can use the following code to check out the results in fit.
#print provides a summary for the parameter of the model as well as the
#log-posterior with name lp__ (see the following example output). For more
#methods and details of class stanfit, see the help of class stanfit.

#In particular, we can use the extract function on stanfit objects to obtain the
#samples. extract extracts samples from the stanfit object as a list of arrays
#for parameters of interest, or just an array. In addition, S3 functions
#as.array, as.matrix, and as.data.frame are defined for stanfit objects (using
#help("as.array.stanfit") to check out the help document in R).


print(fit)
plot(fit)
pairs(fit, pars = c("mu", "tau", "lp__"))

la <- extract(fit, permuted = TRUE) # return a list of arrays 
mu <- la$mu 

### return an array of three dimensions: iterations, chains, parameters 
a <- extract(fit, permuted = FALSE) 

### use S3 functions on stanfit objects
a2 <- as.array(fit)
m <- as.matrix(fit)
d <- as.data.frame(fit)
