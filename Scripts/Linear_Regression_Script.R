---
output: reprex::reprex_document
knit: reprex::reprex_render
---

Load in our packages

library(MASS) # Contains our data
library(ISLR2) # Contains the Boston data set 



# Let's glimpse our dataset
head(Boston)

# Output variable:
# medv - medium house value. Our predictor variable

# Input variable
# rmvar - average number of rooms per house
# age average age of house 
# lstat - percent of households with low socioeconomic status

# Let's use the attach command to lock on our data set
attach(Boston)

# We can use the lm function to fit a simple linear regression model

lm.fit <- lm(medv ~ lstat)

# We can view some of the characteristics of the model
lm.fit

