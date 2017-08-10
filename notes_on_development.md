# Notes on weighted density map development
CSev  
`r format(Sys.Date())`  



## R Markdown

This R Markdown document is meant to show my progess and development of maps that show weighted density in the United States. It is as much an exercise for me to learn a different set of development tools than I have traditionally used. My experience is with Matlab and Stata, and I would like to develop similar proficiency in R. Further, I implement a workflow that includes use of [GitHub](http://www.github.com).

Because some difficulties I've previously experience with spatial data in R, I will try to use the [sf](https://cran.r-project.org/web/packages/sf/vignettes/sf1.html) (simple features) package for all this work.


```r
summary(cars)
```

```
##      speed           dist       
##  Min.   : 4.0   Min.   :  2.00  
##  1st Qu.:12.0   1st Qu.: 26.00  
##  Median :15.0   Median : 36.00  
##  Mean   :15.4   Mean   : 42.98  
##  3rd Qu.:19.0   3rd Qu.: 56.00  
##  Max.   :25.0   Max.   :120.00
```

## Including Plots

You can also embed plots, for example:

![](notes_on_development_files/figure-html/pressure-1.png)<!-- -->

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
