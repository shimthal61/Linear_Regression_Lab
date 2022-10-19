# Non-Linear Regression

Let’s first read in our data for this lab and attach the `Wage` data

``` r
library(ISLR2)
attach(Wage)
```

## Polynomial Regression

Let’s first fit our model using a fourth-degree Polynomial in `age`

``` r
poly_fit <- lm(wage ~ poly(age, 4), data = Wage)
coef(summary(poly_fit))
#>                 Estimate Std. Error    t value     Pr(>|t|)
#> (Intercept)    111.70361  0.7287409 153.283015 0.000000e+00
#> poly(age, 4)1  447.06785 39.9147851  11.200558 1.484604e-28
#> poly(age, 4)2 -478.31581 39.9147851 -11.983424 2.355831e-32
#> poly(age, 4)3  125.52169 39.9147851   3.144742 1.678622e-03
#> poly(age, 4)4  -77.91118 39.9147851  -1.951938 5.103865e-02
```

The model above returns a matrix whose columns are a basis of orthologonal polynomials, which essentially means that each column is a linear combination of the variables `age`, `age^2`, `age^3`, and `age^4`.

We can instead using the `raw = T` argument to directly obtain each `age` polynomials

``` r
poly2_fit <- lm(wage ~ poly(age, 4, raw = TRUE), data = Wage)
coef(summary(poly2_fit))
#>                                Estimate   Std. Error   t value     Pr(>|t|)
#> (Intercept)               -1.841542e+02 6.004038e+01 -3.067172 0.0021802539
#> poly(age, 4, raw = TRUE)1  2.124552e+01 5.886748e+00  3.609042 0.0003123618
#> poly(age, 4, raw = TRUE)2 -5.638593e-01 2.061083e-01 -2.735743 0.0062606446
#> poly(age, 4, raw = TRUE)3  6.810688e-03 3.065931e-03  2.221409 0.0263977518
#> poly(age, 4, raw = TRUE)4 -3.203830e-05 1.641359e-05 -1.951938 0.0510386498
```

We can create a similar model using the `cbind()` function for building a matric from a collection of vectors.

Let’s now create a grid of values for `age` at which we want predictions, and then call then generic `predict()` function, specifying that we want standard error as well

``` r
agelims <- range(age) # Create a vector with the min and max ages
age_grid <- seq(from = agelims[1], to = agelims[2]) # Creates a vector which contains all the values from the first index of age to the last index
preds <- predict(poly_fit, newdata = list(age = age_grid),
    se = TRUE)
se_bands <- cbind(preds$fit + 2 * preds$se.fit,
    preds$fit - 2 * preds$se.fit)
```

Finally, we plot the data and add the fit from the degree-4 polynomial.

``` r
par(mfrow = c(1, 2), mar = c(4.5, 4.5, 1, 1),
    oma = c(0, 0, 4, 0)) # Set the physical margins and parameters of the plot
plot(age, wage, xlim = agelims, cex = .5, col = "darkgrey") # Create the plot using the vectors we created earlier
title("Degree-4 Polynomial", outer = TRUE) # Set the title and location
lines(age_grid, preds$fit, lwd = 2, col = "blue") # Create the fit line from the 4th degree polynomial
matlines(age_grid, se_bands, lwd = 1, col = "blue", lty = 3) # Add in the standard error line
```

![](https://i.imgur.com/AX8hj0m.png)

We can also see whether using an orthogonal set of basic functions will affect our model in a meaningful way

``` r
pred2 <- predict(poly2_fit, newdata = list(age = age_grid),
    se = TRUE)
max(abs(preds$fit - pred2$fit))
#> [1] 7.81597e-11
```

## What degree Polynomial

When performing polynomial Regression we must decide on the degree of the polynomial to use. We can use a null-hypothesis test to determine the simpliest model to explain the relationship between `wage` and `age`.

``` r
for (i in 1:5) { # We first create a for loop with i having a value 1 to 5
    nam <- paste("fit_", i, sep = "") # We create a new variable called fit_i
    assign(nam, lm(wage ~ poly(age, i), data = Wage)) # We carry out a polynomial fit of i and assign it to fit_i
}
anova(fit_1, fit_2, fit_3, fit_4, fit_5) # We run an anova to test the null hypothesis]
#> Analysis of Variance Table
#> 
#> Model 1: wage ~ poly(age, i)
#> Model 2: wage ~ poly(age, i)
#> Model 3: wage ~ poly(age, i)
#> Model 4: wage ~ poly(age, i)
#> Model 5: wage ~ poly(age, i)
#>   Res.Df     RSS Df Sum of Sq        F    Pr(>F)    
#> 1   2998 5022216                                    
#> 2   2997 4793430  1    228786 143.5931 < 2.2e-16 ***
#> 3   2996 4777674  1     15756   9.8888  0.001679 ** 
#> 4   2995 4771604  1      6070   3.8098  0.051046 .  
#> 5   2994 4770322  1      1283   0.8050  0.369682    
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

The *p*-values comparing the linear model to the quadratic model is essentially zero, indicating that the linear fit it not sufficient.

Continuing this logic, it appears as though a cubic or quadratic polynomial appears to provide the most reasonable fit to the data.

Instead of using the `anova()` function, we could have obtained these p-values more succinctly by exploting the fact that `poly()` creates orthogonal polynomials.

``` r
coef(summary(fit_5))
#>                 Estimate Std. Error     t value     Pr(>|t|)
#> (Intercept)    111.70361  0.7287647 153.2780243 0.000000e+00
#> poly(age, i)1  447.06785 39.9160847  11.2001930 1.491111e-28
#> poly(age, i)2 -478.31581 39.9160847 -11.9830341 2.367734e-32
#> poly(age, i)3  125.52169 39.9160847   3.1446392 1.679213e-03
#> poly(age, i)4  -77.91118 39.9160847  -1.9518743 5.104623e-02
#> poly(age, i)5  -35.81289 39.9160847  -0.8972045 3.696820e-01
```

Notice how the *p*-values are the same, with the *t*-statistic equal to the F-statistic from the `anova()`.

The ANOVA method also works when we have more terms in our model

``` r
for (i in 1:5) {
    nam <- paste("fit_", i, sep = "")
    assign(nam, lm(wage ~ education + poly(age, i), data = Wage))
}
anova(fit_1, fit_2, fit_3, fit_4, fit_5)
#> Analysis of Variance Table
#> 
#> Model 1: wage ~ education + poly(age, i)
#> Model 2: wage ~ education + poly(age, i)
#> Model 3: wage ~ education + poly(age, i)
#> Model 4: wage ~ education + poly(age, i)
#> Model 5: wage ~ education + poly(age, i)
#>   Res.Df     RSS Df Sum of Sq        F Pr(>F)    
#> 1   2994 3867992                                 
#> 2   2993 3725395  1    142597 114.7077 <2e-16 ***
#> 3   2992 3719809  1      5587   4.4940 0.0341 *  
#> 4   2991 3719777  1        32   0.0255 0.8731    
#> 5   2990 3716972  1      2805   2.2562 0.1332    
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

# Step functions

In order to fit a step function, we use the `cut()` function. This returns an ordered categorical variable.

``` r
table(cut(age, 4))
#> 
#> (17.9,33.5]   (33.5,49]   (49,64.5] (64.5,80.1] 
#>         750        1399         779          72
```

``` r
step_fit <- lm(wage ~ cut(age, 4), data = Wage)
coef(summary(step_fit))
#>                         Estimate Std. Error   t value     Pr(>|t|)
#> (Intercept)            94.158392   1.476069 63.789970 0.000000e+00
#> cut(age, 4)(33.5,49]   24.053491   1.829431 13.148074 1.982315e-38
#> cut(age, 4)(49,64.5]   23.664559   2.067958 11.443444 1.040750e-29
#> cut(age, 4)(64.5,80.1]  7.640592   4.987424  1.531972 1.256350e-01
```

Here, `cut()` automatically picked the cutpoints at 33.5, 49, and 64.5 years of age.

We can also specify our own cutpoints using the `breaks` argument.

We can create another visualisation with using the same code as before, except we pass through our step function model instead

## Creating a plot

``` r
preds <- predict(step_fit, newdata = list(age = age_grid),
    se = TRUE)
se_bands <- cbind(preds$fit + 2 * preds$se.fit,
    preds$fit - 2 * preds$se.fit)
```

``` r
par(mfrow = c(1, 2), mar = c(4.5, 4.5, 1, 1),
    oma = c(0, 0, 4, 0))
plot(age, wage, xlim = agelims, cex = .5, col = "darkgrey")
title("Degree-4 Step Function", outer = TRUE)
lines(age_grid, preds$fit, lwd = 2, col = "blue")
matlines(age_grid, se_bands, lwd = 1, col = "blue", lty = 3)
```

![](https://i.imgur.com/JUBSlDs.png)

## Deciding which degree

Like with the polynomial regression, we can create a list of different cuts at age within a `for` loop

``` r
for (i in 2:8) {
    nam <- paste("step_", i, sep = "")
    assign(nam, lm(wage ~ cut(age, i), data = Wage))
}
anova(step_2, step_3, step_4, step_5, step_6, step_7, step_8)
#> Analysis of Variance Table
#> 
#> Model 1: wage ~ cut(age, i)
#> Model 2: wage ~ cut(age, i)
#> Model 3: wage ~ cut(age, i)
#> Model 4: wage ~ cut(age, i)
#> Model 5: wage ~ cut(age, i)
#> Model 6: wage ~ cut(age, i)
#> Model 7: wage ~ cut(age, i)
#>   Res.Df     RSS Df Sum of Sq      F    Pr(>F)    
#> 1   2998 5195128                                  
#> 2   2997 5037846  1    157282 98.450 < 2.2e-16 ***
#> 3   2996 4895717  1    142128 88.965 < 2.2e-16 ***
#> 4   2995 4879628  1     16090 10.071  0.001521 ** 
#> 5   2994 4851973  1     27655 17.310 3.264e-05 ***
#> 6   2993 4813508  1     38465 24.077 9.750e-07 ***
#> 7   2992 4779946  1     33562 21.008 4.761e-06 ***
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

``` r
coef(summary(step_8))
#>                        Estimate Std. Error   t value      Pr(>|t|)
#> (Intercept)            76.28175   2.629812 29.006542 3.110596e-163
#> cut(age, i)(25.8,33.5] 25.83329   3.161343  8.171618  4.440913e-16
#> cut(age, i)(33.5,41.2] 40.22568   3.049065 13.192791  1.136044e-38
#> cut(age, i)(41.2,49]   43.50112   3.018341 14.412262  1.406253e-45
#> cut(age, i)(49,56.8]   40.13583   3.176792 12.634076  1.098741e-35
#> cut(age, i)(56.8,64.5] 44.10243   3.564299 12.373380  2.481643e-34
#> cut(age, i)(64.5,72.2] 28.94825   6.041576  4.791505  1.736008e-06
#> cut(age, i)(72.2,80.1] 15.22418   9.781110  1.556488  1.196978e-01
```

# Splines

In order to fit regression splines, we use the splines library.

``` r
library(splines)
```

Regression splines can be fit by constructing an appropriate matrix of basic functions.

The `bs()` function (basis splines) generates the entire matrix of basis functions for splines with the specified set of knots.

By default, cubic splines are produced.

``` r
par(new)
#> Warning in par(new): argument 1 does not name a graphical parameter
#> NULL
spl_fit <- lm(wage ~ bs(age, knots = c(25, 40, 60)), data = Wage) # Here we specify the knots at 25, 40, and 60.
pred <- predict(spl_fit, newdata = list(age = age_grid), se = TRUE)
plot(age, wage, col = "grey")
lines(age_grid, pred$fit, lwd = 2)
lines(age_grid, pred$fit + 2 * pred$se, lty = "dashed")
lines(age_grid, pred$fit - 2 * pred$se, lty = "dashed")
```

![](https://i.imgur.com/8BWmXIu.png)

We can use the `dim()` function to retrieve the dimensions of an object

``` r
dim(bs(age, knots = c(25, 40, 60)))
#> [1] 3000    6
```

We can also use the `attr()` function to get specific attributes of an object

``` r
attr(bs(age, df = 6), "knots")
#>   25%   50%   75% 
#> 33.75 42.00 51.00
```

In this case R chooses knots at ages 33,8, 42.0 and 51.0, which correspond to the 25th, 50th, and 75th percentiles of `age`. The function `bs()`
also has a degree argument, so we can fit splines of any degree, rather than the default degree of 3 (which yields a cubic spline).

## Fitting a natural spline

In order to fit a natural spline, we use the `ns()` (natural spline) function.

``` r
nat_fit <- lm(wage ~ ns(age, df = 4), data = Wage) # Here, we fit a natural spline with 4 degrees of freedom
pred2 <- predict(nat_fit, newdata = list(age = age_grid),
            se = TRUE)
par(new = TRUE)
#> Warning in par(new = TRUE): calling par(new=TRUE) with no plot
plot(age, wage, col = "gray")
lines(age_grid, pred2$fit, col = "red", lwd = 2)
```

![](https://i.imgur.com/sBRoJUV.png)

As with the `bs()` function, we can instead manually specify the knots using the `knots` argument

``` r
par(mfrow = c(1, 2), mar = c(4.5, 4.5, 1, 1),
    oma = c(0, 0, 4, 0))
plot(age, wage, xlim = agelims, cex = .5, col = "darkgrey")
title("Smoothing Splines")
fit <- smooth.spline(age, wage, df = 16) # In our first model, we specify df = 16.
fit2 <- smooth.spline(age, wage, cv = TRUE) # We then select the smoothness level using cross-validation
#> Warning in smooth.spline(age, wage, cv = TRUE): cross-validation with non-unique
#> 'x' values seems doubtful
fit2$df # Using cross-validation has resulted in a df value of 6.8
#> [1] 6.794596
lines(fit, col = "red", lwd = 2)
lines(fit2, col = "blue", lwd = 2)
legend("topright", legend = c("16 DF", "6.8 DF"),
     col = c("red", "blue"), lty = 1, lwd = 2, cex = .8)
```

![](https://i.imgur.com/jZ6o0JJ.png)

# GAMs

We can fit a GAM to predict `wage` using natural spline functions of `lyear` and `age`, treating `education` as a qualitative predictor.

Since this is effectively just a big linear regression model, we can use the `lm()` function

``` r
gam1 <- lm(wage ~ ns(year, 4) + ns(age, 5) + education,
    data = Wage)
```

We need to use the `gam()` library

``` r
library(gam)
#> Loading required package: foreach
#> Loaded gam 1.20.2
```

``` r
gam_m3 <- gam(wage ~
    s(year, 4) + # The s() function indicates the use of smoothing splines, and we specify 4 df
    s(age, 5) + # We do the same here except we want 5 df
    education, # Education is qual, and is converted into four dummy variables
    data = Wage) # The s() function indicates the use of smoothing splines
```

``` r
par(mfrow = c(1, 3))
plot(gam_m3, se = TRUE, col = "blue")
```

![](https://i.imgur.com/k6G7bBs.png)

``` r
plot.Gam(gam1, se = TRUE, col = "red") # We have to use plot.Gam() instead
```

![](https://i.imgur.com/MBF3jTY.png)![](https://i.imgur.com/VQnBJ9h.png)![](https://i.imgur.com/6IvofeA.png)

In the first plot, `lyear` looks rather lienar. We can perform AVOVA tests to determine which model is best:
- One that excludes `lyear`
- One what uses a linear function of `lyear`
- GAM that uses a spline function of `lyear`

``` r
gam_m1 <- gam(wage ~ s(age, 5) + education, data = Wage)
gam_m2 <- gam(wage ~ year + s(age, 5) + education, data = Wage)
anova(gam_m1, gam_m2, gam_m3)
#> Analysis of Deviance Table
#> 
#> Model 1: wage ~ s(age, 5) + education
#> Model 2: wage ~ year + s(age, 5) + education
#> Model 3: wage ~ s(year, 4) + s(age, 5) + education
#>   Resid. Df Resid. Dev Df Deviance  Pr(>Chi)    
#> 1      2990    3711731                          
#> 2      2989    3693842  1  17889.2 0.0001419 ***
#> 3      2986    3689770  3   4071.1 0.3483897    
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Here, we find compelling evidence that a GAM with a lienar function of `lyear` is better than one without.

However, there is no evidence that a non-linear function of `lyear` is needed.

The `summary()` function produces a summary of the GAM fit

``` r
summary(gam_m3)
#> 
#> Call: gam(formula = wage ~ s(year, 4) + s(age, 5) + education, data = Wage)
#> Deviance Residuals:
#>     Min      1Q  Median      3Q     Max 
#> -119.43  -19.70   -3.33   14.17  213.48 
#> 
#> (Dispersion Parameter for gaussian family taken to be 1235.69)
#> 
#>     Null Deviance: 5222086 on 2999 degrees of freedom
#> Residual Deviance: 3689770 on 2986 degrees of freedom
#> AIC: 29887.75 
#> 
#> Number of Local Scoring Iterations: NA 
#> 
#> Anova for Parametric Effects
#>              Df  Sum Sq Mean Sq F value    Pr(>F)    
#> s(year, 4)    1   27162   27162  21.981 2.877e-06 ***
#> s(age, 5)     1  195338  195338 158.081 < 2.2e-16 ***
#> education     4 1069726  267432 216.423 < 2.2e-16 ***
#> Residuals  2986 3689770    1236                      
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
#> 
#> Anova for Nonparametric Effects
#>             Npar Df Npar F  Pr(F)    
#> (Intercept)                          
#> s(year, 4)        3  1.086 0.3537    
#> s(age, 5)         4 32.380 <2e-16 ***
#> education                            
#> ---
#> Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

The `Anova for Parametric Effects` *p*-values clearly demonstrate that `year`, `age` , and `education` are all highly statistically significant, evenwhen only assuming a linear relationship.
Alternatively, the `Anova for Nonparametric Effects` *p*-values for `year` and `age` correspond to anull hypothesis of a linear relationship versus the alternative of a non-linear relationship.
The large *p*-value for year reinforces our conclusion from the ANOVA test that a linear function is adequate for this term.
However, there is very clear evidence that a non-linear term is required for `age`. We can make predictions using the `predict()` method for the class `Gam`.
Here we make predictions on the training set.

``` r
preds <- predict(gam_m2, newdata = Wage)
```

<sup>Created on 2022-10-19 with [reprex v2.0.2](https://reprex.tidyverse.org)</sup>
