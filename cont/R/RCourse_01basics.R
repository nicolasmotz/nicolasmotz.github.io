#############
#
# First step in most cases: set working directory
#
#############






#############
#
# Installing and using packages
#
#############

# Particularly easy in RStudio


#############
#
# Basic operations
#
#############

### Basic maths ###











### Logical operations ###















##############
#
# Creating and removing variables
#
##############







### Vectors/Lists ###








#!!!!!EXERCIZE!!!!!#
#
# Recreate these vectors:
# (1,2,...,99,100)
# (1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2)
# (1,2,3,4,4,4,4)
# (2,3,6,8,8,8,8)
# (1,4,9)









### Matrices ###










#!!!!!EXERCISE!!!!!#
# Creat a 3x2 matrix C that has 2s in the first column and 3s in the second column
# Add 2 to every element of C
# Multiply all elements of the second row of C by 4 








### Strings ###









#!!!!!EXERCISE!!!!!#
# Attach ", PhD" to every entry of vector names (with no space in front!)
# Create a vector called gender of length 4 where each entry is either "m" or "female" (at least one of each!)
# Replace every entry of vector gender equal to "female" with "f"







### Working with dates ###






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



### Factors ###




### Look at part of data frame ###







### Add a variable ###




#!!!!!EXERCISE!!!!!#
# Look at subset of mydata for all female professors and variables birthdays and height
# Add a variable heightcm that contains the person's height in cm




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



# apply does the same for a matrix, with possibility along which dimension of matrix the function should be applied.


# tapply divides a vector into groups and applies the provided function to each group






##################
#
# User-defined functions
#
##################







#!!!!!EXERCISE!!!!!#
#
# Write a function called distance that calculates the distance of a number from 10
# and apply this function to each element of the vector 1:10
#








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