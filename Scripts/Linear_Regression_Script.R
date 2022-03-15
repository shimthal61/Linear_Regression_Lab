library(MASS) #Hasa very large collection of dasta sets and funcitons
library(ISLR2) # Includes the datasets assocaited with this module

head(Boston)

lm.fit <- lm(medv ~ lstat, data = Boston)
attach(Boston)

summary(lm.fit)

names(lm.fit)

coef(lm.fit) # Looking at the coefficients

confint(lm.fit) #97.5% CI

predict(lm.fit, data.frame(lstat = (c(5, 10, 15))),
        interval = "confidence") # Producing CI and predicted intervals of medv
# a given value of lstat

predict(lm.fit, data.frame(lstat = (c(5, 10, 15))),
        interval = "prediction")

# Plottimedv and lstat along with the least squares regression line
plot(lstat, medv)
abline(lm.fit)

# Some evidence for non-linearity in their relationship

# The lwd argument changes the width of the regression line.

# Different graph types:
plot(lstat, medv)
abline(lm.fit, lwd = 3)
abline(lm.fit, lwd = 3, col = "red")
plot(lstat, medv, col = "red")
plot(lstat, medv, pch = 20) # pch argument is for different plot point types
plot(lstat, medv, pch = "+")
plot(1:20, 1:20, pch = 1:20) # Showing different pch types

# We can create some diagnostic plots and tell R to show all 4 plots in a 2x2 grid

par(mfrow = c(2, 2))
plot(lm.fit)

# We can also compute the residuals using the residuals() function

plot(predict(lm.fit), residuals(lm.fit))
plot(predict(lm.fit), rstudent(lm.fit))

plot(hatvalues(lm.fit)) # Calculating leverage statistics 

# Identifies the index of the largest element of a vector. Tell us which observation
# has the largest leverage statistic
which.max(hatvalues(lm.fit))