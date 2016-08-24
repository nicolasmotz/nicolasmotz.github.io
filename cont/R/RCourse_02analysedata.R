setwd("~/MEGA/MEGAsync/Academia/R course")

###########
#
# Read data
#
###########



# turn single in to factor






# Compute the age of each respondent
# source: http://stackoverflow.com/questions/3611314/calculating-ages-in-r
# 
# Neat example of writing your own function and applying it to a vector
# The function takes two dates and converts them to the POSIXlt format for handling dates
# Then it computes how many years the dates are apart, just by looking at the year-part of the date.
# This makes some people one year to old, since their birthday hasn't happened yet in the current 
# year. The ifelse statement at the end of the function corrects for this.
comp_age = function(from, to) {
  from_lt = as.POSIXlt(from, origin = "1970-01-01")
  to_lt = as.POSIXlt(to, origin = "1970-01-01")
  
  age = to_lt$year - from_lt$year
  
  ifelse(to_lt$mon < from_lt$mon |
           (to_lt$mon == from_lt$mon & to_lt$mday < from_lt$mday),
         age - 1, age)
}

# mapply then applys the function comp_age to every row of poke, using date_birth as 
# the first argument of the function and date_surv as the second argument.

poke$age <- mapply(comp_age,poke$date_birth,poke$date_surv)


rm(comp_age)





### Save the dataset ###


save(poke, file = "pokemon_data.Rda")




##############
#
# Descriptive statistics
#
##############





# By group 




#!!!!!EXERCISE!!!!!#
#
# Compute mean and variance of intensity of use by gender 
#








##############
#
# Linear Regression
#
##############




### Multiple regression ###




# Regress income on all variables in data set except obs




# Regression with interaction between, say, age and gender

lm(income ~ age + gender + age:gender, data = poke) # : adds an interaction term between two specific variable

lm(income ~ age * gender, data = poke) # * adds variables and all of their interactions. So x1*x2*x3 would add three variables and 4 interactions.

lm(income ~ (age + gender)^2, data = poke) # ^ adds variables and all interactions up to specified degree. So x1*x2*x3 equivalent to (x1+x2+x3)^3


# Regression on age and quadratic in age

lm(income ~ age + I(age^2), data=poke) # Within I() all mathematical operations work as usual



# See also http://faculty.chicagobooth.edu/richard.hahn/teaching/formulanotation.pdf
# for how to write equations for models




### Closer look at regression results



#!!!!!EXERCISE!!!!!#
#
# Manually calculate R^2 for regression reg1 
#




#!!!!!EXERCISE!!!!!#
# 
# Run a regression of income on variables intens, age, age^2, occup and save result as object regSing
#
# Run a linear probability model for variable single with explanatory variables intens, age, age^2, occup
# and save result as object regInc








#################
#
# Instrumental variable regression
#
#################


library(AER) # for ivreg()






#################
#
# Logit
#
#################

LogitSing <- glm(single ~ intens + age + I(age^2) + occup, family=binomial(link='logit'), data=poke)

# To get marginal effects, could use package mfx...or write our own function that calculates them
