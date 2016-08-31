#############
#
# First step in most cases: set working directory
#
#############


setwd("~/MEGA/MEGAsync/Academia/R course")



#############
#
# Installing and using packages
#
#############

# Particularly easy in RStudio

library(ggplot2)



#############
#
# Basic operations
#
#############

### Basic maths ###

1 + 1
2 - 1

6*6

2^3
2**8

abs(-4)

sqrt(81)

log(exp(1))


### Logical operations ###

2 > 1
2 < 1

2 >= 2
2 == 2

! 2 > 1

4 > 1 & 4 > 2
4 > 1 & 4 > 5

4 > 1 | 4 > 5





##############
#
# Creating and removing variables
#
##############

x <- 4
y = 9

rm(x,y)


### Vectors/Lists ###

v <- c(1,2,3)
v <- 1:3

w <- rep(4, times = 4)
w <- rep(4,4)

w[1]
w[1:2]



#!!!!!EXERCIZE!!!!!#
#
# Recreate these vectors:
# (1,2,...,99,100)
# (1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2)
# (1,2,3,4,4,4,4)
# (2,3,6,8,8,8,8)
# (1,4,9)

1:100
rep(c(1,2),3)
c(v,w)
c(v,w)*2
v^2



### Matrices ###

A <- matrix(nrow = 2)
A <- matrix(1:9,nrow = 3)
A <- matrix(1:9,ncol = 3)
A <- matrix(1:9,ncol = 3, byrow = TRUE)

t(A)

cbind(A,v)
rbind(A,v)

B <- diag(nrow = 3)
B <- diag(4, nrow = 3)
B <- diag(v)

A*B
A%*%B
v%*%A
A%*%v
A%*%t(v)

A[1,2]
A[,2]


#!!!!!EXERCISE!!!!!#
# Creat a 3x2 matrix C that has 2s in the first column and 3s in the second column
# Add 2 to every element of C
# Multiply all elements of the second row of C by 4 

C <- matrix( c(rep(2,3), rep(3,3)), nrow = 3)
C <- C+2
C[2,] <- C[2,]*4






### Strings ###

names <- c("Nic", "Warn", "Mink", "Ann")
title <- c("Senor", "Queen", "Professor", "Professor")

substring("Economics",1,4)

paste("you","me")
paste("you","me", sep = "+")
paste("you","me", sep = "ng & la" )

names <- paste(title,names)

sub("Professor", "Prof.", title)
rm(title)

grepl("can","American")
grepl("can't","AmeriCAN")

grep("can","American")

#!!!!!EXERCISE!!!!!#
# Attach ", PhD" to every entry of vector names (with no space!)
# Create a vector called gender of length 4 where each entry is either "m" or "female" (at least one of each!)
# Replace every entry of vector gender equal to "female" with "f"

names <- paste(names, ", PhD", sep ="")
gender <- c("female", "female", "m", "female")
gender <- sub("female","f",gender)





### Working with dates ###

birthday <- as.Date("1981-09-20")
today <- as.Date("2016-08-23")
  
today - birthday

as.numeric(birthday)
birthday - as.Date("1970-01-01")
  
birthdays <- c(3012,5982,2094) 
birthdays <- as.Date(birthdays, origin = "1970-01-01")

birthdays <- c(birthday,birthdays)

rm(birthday)




###############
#
# Checking propoerties of objects
#
###############

# class of object
# functions often require a certain class
class(v)
class(A)
class(gender)
class(birthdays)

# mode of data contained in object
mode(v)
mode(A)
mode(gender)

# get mode and additional info ("attributes)
str(v)
str(birthdays)
str(A)

# length/dimension
length(v)
length(birthdays)

dim(A)
dim(v)






################
#
# Data frames
#
################

# from R help
# "tightly coupled collections of variables which share many of the properties of matrices
#  and of lists, used as the fundamental data structure by most of R's modeling software."

mydata <- data.frame(names, birthdays, gender, stringsAsFactors = FALSE)

str(mydata)


### Factors ###

ifelse(grepl("f",mydata$gender),1,0)

mydata$gender <- as.factor(mydata$gender)


### Look at part of data frame ###

mydata$names

mydata[1:2,]

mydata[mydata$birthdays>"1980-01-01",]

mydata[mydata$birthdays>"1980-01-01",c("names","birthdays")]


### Add a variable ###

mydata$height <- rnorm(4, 1.7, 0.4)



#!!!!!EXERCISE!!!!!#
# Look at subset of mydata for all female professors and variables birthdays and height
# Add a variable heightcm that contains the person's height in cm

mydata[mydata$gender=="f",c("birthdays","height")]
mydata[mydata$gender==2,c("birthdays","height")] # Does not work!
mydata[grepl("f",mydata$gender),c("birthdays","height")]

mydata$heightcm <- mydata$height*100


##################
#
# Storing objects
#
##################

#
# Always make sure that working directory is set correctly before using these commmands
#    ...or explicitly include the path to the object.
#


# Save whole workspace

save.image("first_session.RData")
load("first_session.RData")


# Save object in format specific to R. Can continue working next time where we left off
save(mydata, file = "mydata.Rda")
load("mydata.Rda")

# Export object to read with other software
# If load such a file into R again, some of the formatting will have typically been lost  

write.table(mydata, file = "mydata.txt")
write.csv(mydata, file = "mydata.csv")

read.table("mydata.txt")
read.csv("mydata.csv")

# Reading tables correctly typically requires providing additional options
# See next session and help for each command





##################
#
# Missing values
#
##################

# Encoded as NA (this is not the same as "NA"!)

x <- NA

x == NA #NO! BAD!

is.na(x) #Ah, better

x <- c(1:4,x)
x[1] <- NA

mean(x)
mean(x, na.rm = TRUE)


### Careful with logic and NAs ###

TRUE & NA
# result is NA as long as result is not clear

FALSE & NA
# This returns FALSE because FALSE & something is always FALSE





##################
#
# *apply
#
##################

# lapply: apply a function to each element of a vector or list

lapply(1:4,sqrt)

sapply(1:4,sqrt) # Same as lapply, but with simplified output


sqrt(1:4)

# apply does the same for a matrix, with possibility along which dimension of matrix the function should be applied.


# tapply divides a vector into groups and applies the provided function to each group

tapply(mydata$height,mydata$gender, mean)





##################
#
# User-defined functions
#
##################

f <- function(x) {
  y <- sqrt(x)
  return(y)
}

helloR <- function() {
  print("Hello user!")
}




#!!!!!EXERCISE!!!!!#
#
# Write a function called distance that calculates the distance of a number from 10
# and apply this function to each element of the vector 1:10
#

distance <- function(x) {
  y <- sqrt((x-10)^2)
  return(y)
}

sapply(1:10,distance)





##################
#
# Remarks
#
##################
#
# Types of objects not (fully) covered:
#
# Lists: Actually not the same as a vector. Flexible structures. 
#        Every element of a list can be a different type of object, including another list.
#        Every vector is a list though.
# 
# Arrays: More than two-dimensional matrices
#
#
#