lm.fit <- lm(medv ~ lstat + age, data = Boston)

summary(lm.fit)

# Instead of typing all of the variables, we can use the following short hand:

lm.fit <- lm(medv ~ ., data = Boston)
summary(lm.fit)

summary(lm.fit)$r.sq # This gives us R^2
summary(lm.fit)$sigma # Gives us RSE

library(car)
vif(lm.fit) # Can compute variance inflation factors

# The syntax for including all variables bar one
lm.fit1 <- lm(medv ~ . - age, data = Boston)

summary(lm.fit1)

# We can also use the update() function to do this

lm.fit1 <- update(lm.fit, ~ . - age)
summary(lm.fit1)

# We add interaction terms within the lm() function.
# Similar to Andrew's general linear model syntax

summary(lm(medv ~ lstat * age, data = Boston))

# The I() function allows us to use the x^2 syntax to raise x to the power of 2
lm.fit2 <- lm(medv ~ lstat + I(lstat^2))
summary(lm.fit2)

# Our p value is very low suggests that our quadratic model is better. Let's carry out a LRT

anova(lm.fit, lm.fit2)

# The model containing th predictors lstat and lstat^2 is far superior to the model that
# only contains the predictor lsat. 

par(mfrow = c(2, 2))
plot(lm.fit2)

# We see that when lstat^2 there is a little discernible pattern in the residuals

# We can also create a cubic fit, we can use I(X^3), although this can be cumbersome.

# A better approach uses poly() function to create the polynomial within lm().

lm.fit7 <- lm(medv ~ poly(lstat, 7)) # This produces a fifth=order polynomial fit
summary(lm.fit7)

# This suggests that including additional polynomial terms, up to the fifth order, leads
# to an improvement in the model fit. However, this effect disappears when more terms are added

# In order to obtain raw polynomials from the poly() function, the argument raw=TRUE must be used

# We can also try a log transformation
summary(lm(medv ~ log(rm), data = TRUE))

# Let's not examine the Carseats data

library(tidyverse)

head(Carseats)

contrasts(Carseats$ShelveLoc)

lm.fit <- lm(Sales ~ . + Income:Advertising + Price:Age,
             data = Carseats)

summary(lm.fit)
