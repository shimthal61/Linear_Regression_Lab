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

![](https://i.imgur.com/wfRLxGY.png)

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

In order to fit a step function, we use the `cut()` function

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

We can create another visualisation with using the same code as before, except we pass through our step function model instead

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

![](https://i.imgur.com/DMlpSSW.png)

<sup>Created on 2022-10-19 with [reprex v2.0.2](https://reprex.tidyverse.org)</sup>
