setwd("~/MEGA/MEGAsync/Academia/R course")

###########
#
# Read data
#
###########

poke <- read.table("pokemon_data.txt")

poke <- read.table("pokemon_data.txt", header = TRUE, na.strings = ".")

str(poke)

poke$date_surv <- as.Date(poke$date_surv)
poke$date_birth <- as.Date(poke$date_birth)

# turn single in to factor
poke$single <- ifelse(poke$single==1 & ! is.na(poke$single),"single","not single")
poke$single <- factor(poke$single)



# Look at part of data frame

poke$region

poke[1:2,]

poke[poke$income>100000,c("use","intens")]

poke[poke$income>100000 &! is.na(poke$income),c("use","intens")]




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

load("pokemon_data.Rda")


##############
#
# Descriptive statistics
#
##############

round(sapply(poke, mean, na.rm=TRUE),digits = 2)

summary(poke)

library(pastecs)
stat.desc(poke)#, desc = FALSE)

library(psych)
describe(poke)

# By group 
tapply(poke$single,poke$occup,mean)
describe.by(poke,poke$occup)  # from package psych

mean(poke$intens)
mean(poke[poke$use==1 & !is.na(pokemon$use),]$intens)



#!!!!!EXERCISE!!!!!#
#
# Compute mean and variance of intensity of use by gender 
#

tapply(poke$intens, poke$gen, mean)
tapply(poke$intens, poke$gen, var)






##############
#
# Linear Regression
#
##############

reg1 <- lm(poke$income ~ poke$age)



reg1 <- lm(income ~ age, data = poke)


# No intercept
reg1 <- lm(income ~ -1 + age, data = poke)


### Multiple regression ###

reg2 <- lm(income ~ age + occup, data = poke)
summary(reg2)

reg2 <- lm(income ~ age + occup, data = poke[grepl("white",poke$occup) |grepl("blue", poke$occup),])
summary(reg2)

# Regress income on all variables in data set except obs

lm(income ~ . - obs, data=poke)

# Regression with interaction between, say, age and gender

lm(income ~ age + gender + age:gender, data = poke) # : adds an interaction term between two specific variable
lm(income ~ age * gender, data = poke) # * adds variables and all of their interactions. So x1*x2*x3 would add three variables and 4 interactions.
lm(income ~ (age + gender)^2, data = poke) # ^ adds variables and all interactions up to specified degree. So x1*x2*x3 equivalent to (x1+x2+x3)^3

# Regression on age and quadratic in age

lm(income ~ age + I(age^2), data=poke) # Within I() all mathematical operations work as usual


# See also http://faculty.chicagobooth.edu/richard.hahn/teaching/formulanotation.pdf
# for how to write equations for models




### Closer look at regression results

reg1$coefficients # or reg1$coef
reg1$fitted.values[1:10] # or reg1$fitted
reg1$residuals[1:10] # or reg1$res[1:10]
plot(reg1)




#!!!!!EXERCISE!!!!!#
#
# Manually calculate R^2 for regression reg1 
#

m <- mean(poke$income, na.rm = TRUE)
SS <- (poke[!is.na(poke$income),]$income-m)^2
SS <- sum(SS)
SE <- (reg1$fitted-m)^2
SE <- sum(SE)
SE/SS

rm(SE,SS,m)

#!!!!!EXERCISE!!!!!#
# 
# Run a regression of income on variables intens, age, age^2, occup and save result as object regSing
#
# Run a linear probability model for variable single with explanatory variables intens, age, age^2, occup
# and save result as object regInc


regInc <- lm(income ~ intens + age + I(age^2) + occup, data=poke)
summary(regInc)

regSing <- lm(single ~ intens + age + I(age^2) + occup, data=poke)
summary(regSing)





#################
#
# Instrumental variable regression
#
#################


library(AER) # for ivreg()


regIncIV <- ivreg(income ~ intens + age + I(age^2) + occup | ifelse(grepl("North",poke$region),1,0) + age + I(age^2) + occup, data=poke)
summary(regIncIV)

regSingIV <- ivreg(ifelse(poke$single=="single",1,0) ~ intens + age + I(age^2) + occup | ifelse(grepl("North",poke$region),1,0) + age + I(age^2) + occup, data=poke)
summary(regSingIV, diagnostics = TRUE)




#################
#
# Logit
#
#################

LogitSing <- glm(single ~ intens + age + I(age^2) + occup, family=binomial(link='logit'), data=poke)

# To get marginal effects, could use package mfx...or write our own function that calculates them
