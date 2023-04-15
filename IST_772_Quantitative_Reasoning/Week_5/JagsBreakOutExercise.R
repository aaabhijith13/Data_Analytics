# Jags Tutorial - For IST772

# Here's the JAGS model we will be using, stored as a string
two_indep_means="
  model {
  # This code was built upon an example developed by Rasmus Baath
  # We are creating an acyclic graph that connects all of the terms
  # to one another with definitions for each term.

  # We need separate setups for including data points from x and y
  # because the vector lengths may differ

  # First, we need a node in our graph for each value of x
  for(i in 1:length(x)) {
    x[i] ~ dt( mu_x , tau_x , nu ) # Modeling x as a function of t
  }
  
  # This proposes the t distribution as the posterior distribution for values of x
  # note that mu, tau, and nu are defined later in the model
  x_pred ~ dt( mu_x , tau_x , nu ) # The tilde is distributional notation


  # Now, we need a node in our graph for each value of y
  for(i in 1:length(y)) {
    y[i] ~ dt( mu_y , tau_y , nu ) # We are also modeling y as a function of t
  }
    
  # This proposes the t distribution as posterior distribution for values of y
  # note that mu, tau, and nu are defined later in the model  
  y_pred ~ dt( mu_y , tau_y , nu ) # The tilde is distributional notation

  # Let's track the effect size for each MCMC estimate
  # pow() is the JAGS command to raise a value to a power
  eff_size <- (mu_x - mu_y) / sqrt((pow(sigma_x, 2) + pow(sigma_y, 2)) / 2)
  mu_diff <- mu_x - mu_y 
  sigma_diff <- sigma_x - sigma_y 
  
  # The priors for x
  mu_x ~ dnorm( mean_mu , precision_mu ) # Normal distribution: non-committal
  tau_x <- 1/pow( sigma_x , 2 ) # Precision is 1/variance
  sigma_x ~ dunif( sigmaLow , sigmaHigh ) # Uniform distribution: uninformative

  # The priors for y
  mu_y ~ dnorm( mean_mu , precision_mu ) # Normal distribution: non-committal
  tau_y <- 1/pow( sigma_y , 2 ) # Precision is 1/variance
  sigma_y ~ dunif( sigmaLow , sigmaHigh ) # Uniform distribution: uninformative

  # Set an exponentially distributed prior on nu that starts at 1.
  # 29 is the threshold between small values of df where t has heavy tails
  # and large values of df where t approximates the normal distribution
  nu <- nuMinusOne+1
  nuMinusOne ~ dexp(1/29)
}
"


# Make sure JAGS is installed for native OS
# along with these packages:
# install.packages("rjags")
# install.packages("MCMCvis")
library("rjags")

####################################################
# Model the difference between two independent means

# Here's where we set up the data that we want to model.
# You can change this to contain two independent groups
# from any data source.
x <- mtcars$mpg[mtcars$am==0]
y <- mtcars$mpg[mtcars$am==1]


####################################################
# JAGS model setup begins here:

# Set up the priors 
mean_mu = mean(c(x, y)) # Set the means
precision_mu = 1 / (mad( c(x, y) )^2 * 1000000) # Precision is inverse of variance
sigmaLow = mad( c(x, y) ) / 1000 # mad is mean absolute deviation
sigmaHigh = mad( c(x, y) ) * 1000

# This makes a list and then provides initial
# values for all of the elements in the JAGS
# model. Compare with the model string
inits_list <- list(
  mu_x = mean(x), mu_y = mean(y),
  sigma_x = mad(x), sigma_y = mad(y),
  nuMinusOne = 4)

# This makes a list and then copies in all of 
# the data elements that the JAGS model needs
# in order to run. 
data_list <- list(
  x = x, y = y,
  mean_mu = mean_mu,
  precision_mu = precision_mu,
  sigmaLow = sigmaLow,
  sigmaHigh = sigmaHigh)

# These are the parameters we want to monitor.
# JAGS will create code to maintain a record of each of
# these variables for every MCMC sample drawn.
params <- c("mu_x", "mu_y", "mu_diff", "sigma_x", "sigma_y", "sigma_diff",
            "nu", "eff_size", "x_pred", "y_pred")

# Run the model using the JAGS code from the text file.
model <- jags.model(textConnection(two_indep_means), data = data_list,
                    inits = inits_list, n.chains = 3, n.adapt=1000)

# View(model) # Optionally review the contents of the model object.

# This first step runs the burn-in samples, while
# the second step continues the model run with the 
# post burn-in iterations.
update(model, 1000) # You can change the length of the burn-in samples
samples <- coda.samples(model, params, n.iter=10000) # You can increase the MCMC iterations.

# Inspecting the posterior
plot(samples, trace=F) # Give a density plot
plot(samples, density=F) # Give a trace plot; takes a while!
summary(samples) # Summrize the run

# The bandwidth is calculated by 1.06 times the 
# minimum of the standard deviation and the interquartile range 
# divided by 1.34 times the sample size to the negative one fifth power
plot(samples[,"mu_diff"]) # Give the trace and density plots for mu_diff

# Compare these results to a t-test
