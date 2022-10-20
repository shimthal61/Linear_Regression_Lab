First, we load in and attach our our dataset

``` r
library(ISLR2)
names(Smarket)
#> [1] "Year"      "Lag1"      "Lag2"      "Lag3"      "Lag4"      "Lag5"     
#> [7] "Volume"    "Today"     "Direction"
```

``` r
dim(Smarket) # View the number of rows and columns
#> [1] 1250    9
```

We can use the `pairs()` function to create a scatterplot matrix of all the variables.

The `cor()` function produces a matrix of all the pairwise correlations among the predictors.
We have to omit `direction` as it is a qualitative predictor

``` r
pairs(Smarket)
```

![](https://i.imgur.com/XRdqaJZ.png)

``` r
cor(Smarket[, -9])
#>              Year         Lag1         Lag2         Lag3         Lag4
#> Year   1.00000000  0.029699649  0.030596422  0.033194581  0.035688718
#> Lag1   0.02969965  1.000000000 -0.026294328 -0.010803402 -0.002985911
#> Lag2   0.03059642 -0.026294328  1.000000000 -0.025896670 -0.010853533
#> Lag3   0.03319458 -0.010803402 -0.025896670  1.000000000 -0.024051036
#> Lag4   0.03568872 -0.002985911 -0.010853533 -0.024051036  1.000000000
#> Lag5   0.02978799 -0.005674606 -0.003557949 -0.018808338 -0.027083641
#> Volume 0.53900647  0.040909908 -0.043383215 -0.041823686 -0.048414246
#> Today  0.03009523 -0.026155045 -0.010250033 -0.002447647 -0.006899527
#>                Lag5      Volume        Today
#> Year    0.029787995  0.53900647  0.030095229
#> Lag1   -0.005674606  0.04090991 -0.026155045
#> Lag2   -0.003557949 -0.04338321 -0.010250033
#> Lag3   -0.018808338 -0.04182369 -0.002447647
#> Lag4   -0.027083641 -0.04841425 -0.006899527
#> Lag5    1.000000000 -0.02200231 -0.034860083
#> Volume -0.022002315  1.00000000  0.014591823
#> Today  -0.034860083  0.01459182  1.000000000
```

We can see that the correlations between `lag` variables and `Today` returns are close to zero,
In other words, there appears to be little correlation between today’s returns and the previous days’ returns.
The only substantial correlation is between `year` and `volume`.

<sup>Created on 2022-10-20 with [reprex v2.0.2](https://reprex.tidyverse.org)</sup>
