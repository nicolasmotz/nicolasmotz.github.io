setwd("~/MEGA/MEGAsync/Academia/R course")
load("pokemon_data.Rda")

################
#
# Creating graphs
#
################

### Histogram ###

hist(poke$age)
hist(poke$age, breaks = 20)



### Bar plot + styling a plot###

set.seed(123)
r <- runif(4)
r2 <- runif(4)

barplot(rbind(r,r2), horiz = TRUE, xlim = c(0,1))

barplot(rbind(r,r2), horiz = TRUE, xlim = c(0,1),beside=TRUE, col = c("cadetblue","coral2"),
        names.arg = c("A","B","C","D"), las=1)

# List of available colors:
# http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf



### Scatter plot + adding more elements to  plot###

poke2 <- poke[poke$use==1,]
reg <- lm(intens~income, data=poke2)

plot(poke2$income,poke2$intens)
lines(poke2[!is.na(poke2$income),]$income,reg$fitted, col=4)
abline(reg$coef[1],reg$coef[2])




### Setting graphics parameters for subsequent plots: the par() function

# Save default settings

def.par <- par(no.readonly = T)



plot(poke2$income,poke2$intens)
par(lwd=2, col=4)
abline(5,-0.001)
abline(5,0.001)
par(def.par)





### Combining multiple plots ###
par(mfrow=c(1,2))
plot(poke$income,poke$age)
plot(poke$income,poke$intens)
par(def.par)








################
#
# Exporting graphs
#
################

png('graph.png', width=4.5, height=4)

# code for graph

dev.off()




pdf('graph.pdf', width=4.5, height=4)

# code for graph


dev.off()






################
#
# The ggplot2 package
#
# Find a tutorial at 
# http://tutorials.iq.harvard.edu/R/Rgraphics/Rgraphics.html#orgheadline59
# 
# Also useful:
# https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf
#
################

# As comparison
plot(poke$age,poke$income)

library(ggplot2)

ggplot(poke, aes(x=age,y=income)) + geom_point() 

g1 <- ggplot(poke, aes(x=age,y=income)) + geom_point(aes(col=gen)) 



# add a fitted line to the plot

g1 + geom_smooth()
g1 + geom_smooth(method = "lm", se = FALSE)



### Themes ###

g1 + theme_bw()
g1 + theme_light()
g1 + theme_minimal()
g1 + theme_dark()



### Separate plots based on categorical variable ###

ggplot(poke, aes(x = age)) + geom_histogram() + facet_wrap(~occup)







############
#
# Simple example of how R can be used to illustrate theoretical results
# Code below generates plot with income and substitution effect
# Making plots for a lecture like this might be too much effort,
# but for a publication...
#
############




# Demands and indirect utility function for person with 
# utility function U(x,y)=x^0.5*y^0.5
dx <- function(p1,p2,I) I/(2*p1)
dy <- function(p1,p2,I) I/(2*p2)
U <- function(p1,p2,I) dx(p1,p2,I)^0.5*dy(p1,p2,I)^0.5

# Generate two indifference curves

x <- 1:200/10 
y1 <- (U(8,2,16)/(x^0.5))^(1/0.5) # Indifference curve through optimal bundle at prices 8 and 2 and income 16
y2 <- (U(2,2,16)/(x^0.5))^(1/0.5) # Indifference curve through optimal bundle at prices 2 and 2 and income 16


# Create plot
par(lwd = 1.5, cex = 0.7) # Adjust line width and scale of text and points
# Plot indifference curve with no space between axis and plot (xaxs = "i" and
# yaxis ="i"), a box of shape L, no plotting of axis.
plot(x,y1, type = "l",xlim =c(0,13), ylim = c(0,9), xaxs = "i",
     yaxs = "i", bty = "L", xaxt = "n", yaxt = "n", xlab = "Good x", ylab = "Good y")
points(x,y2, type = "l") # Second indifference curve
abline(8,-4) # Budget set before price decrease
abline(8,-1) # Budget set after price decrease
# Add points to show optimal bundles
points(dx(8,2,16),dy(8,2,16))
points(dx(2,2,16),dy(2,2,16))
points(dx(2,2,8),dy(2,2,8))
par(lty=2) # Subsequent lines dashed
abline(4,-1, lty=2) # Budget set at which consumer would be indifferent after price change
par(xpd=NA) # Allow plotting outside of plotting area
lines(c(dx(2,2,16),dx(2,2,16)),c(dy(2,2,16),0), lty=2)
lines(c(dx(2,2,8),dx(2,2,8)),c(dy(2,2,8),0), lty=2)
lines(c(dx(8,2,16),dx(8,2,16)),c(dy(8,2,16),0), lty=2)
par(lty=1)
# Add some tick marks
lines(c(dx(2,2,16),dx(2,2,16)),c(0,-0.2), lty=2)
lines(c(dx(2,2,8),dx(2,2,8)),c(0,-0.2), lty=2)
lines(c(dx(8,2,16),dx(8,2,16)),c(0,-0.2), lty=2)
text(dx(8,2,16),-0.6,labels="Subs. effect", pos=2)
arrows(dx(8,2,16),-0.6,dx(2,2,8),-0.6, code=2, length=0.05)
text(dx(2,2,8),-1.2,labels="Income effect", pos = 2)
arrows(dx(2,2,16),-1.2,dx(2,2,8),-1.2, code=1, length=0.05)
par(def.par)
