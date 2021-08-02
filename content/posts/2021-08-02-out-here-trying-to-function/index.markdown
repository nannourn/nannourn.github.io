---
title: We Out Here Tryin' to Function
author: Nan Nourn
date: '2021-08-02'
slug: []
categories: [R]
tags: [tidyverse, function, programming]
summary: Creating a function for simple ggplots.
twitter:
  image: "/feature.jpg"
  title: "title"
---
![E-40](images/feature.jpg)

I think one of the key steps in making "improvements" on your R journey is to write code that is more clear, concise and short; for me, this usually occurs when I need to create multiple plots of variables when exploring a dataset. 

I find myself usually making simple bar plots using `ggplot` and `geom_col()` to count things. Instead of copying-and-pasting the same ggplot code and altering the the column names in the code like a newbie hack, I recently learned a new function that can handle the tidyverse workflow when making bar plots.

First, we'll use the [palmerpenguins]('https://allisonhorst.github.io/palmerpenguins/') package to make some bar plots. I examine the penguins dataset to see which columns are categorical/discrete and numerical/continuous:


```r
library(tidyverse)
library(palmerpenguins)
theme_set(theme_minimal())

penguins
```

```
## # A tibble: 344 × 8
##    species island    bill_length_mm bill_depth_mm flipper_length_mm body_mass_g
##    <fct>   <fct>              <dbl>         <dbl>             <int>       <int>
##  1 Adelie  Torgersen           39.1          18.7               181        3750
##  2 Adelie  Torgersen           39.5          17.4               186        3800
##  3 Adelie  Torgersen           40.3          18                 195        3250
##  4 Adelie  Torgersen           NA            NA                  NA          NA
##  5 Adelie  Torgersen           36.7          19.3               193        3450
##  6 Adelie  Torgersen           39.3          20.6               190        3650
##  7 Adelie  Torgersen           38.9          17.8               181        3625
##  8 Adelie  Torgersen           39.2          19.6               195        4675
##  9 Adelie  Torgersen           34.1          18.1               193        3475
## 10 Adelie  Torgersen           42            20.2               190        4250
## # … with 334 more rows, and 2 more variables: sex <fct>, year <int>
```

An easy first look at exploring a dataset is to simply count the number of items in a variable. I want to determine the counts across the categorical columns and make a bar plot for each. That happens to be the `species`, `island` and `sex` columns. Here's the long way how to do it:


```r
penguins %>% 
  drop_na() %>% 
  count(species, sort = TRUE) %>% 
  mutate(species = fct_reorder(species, n)) %>% 
  ggplot(aes(x = species, y = n)) + 
  geom_col() +
  coord_flip()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-2-1.png" width="672" />

```r
penguins %>% 
  drop_na() %>% 
  count(island, sort = TRUE) %>% 
  mutate(island = fct_reorder(island, n)) %>% 
  ggplot(aes(x = island, y = n)) + 
  geom_col() +
  coord_flip()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-2-2.png" width="672" />

```r
penguins %>% 
  drop_na() %>% 
  count(sex, sort = TRUE) %>% 
  mutate(sex = fct_reorder(sex, n)) %>% 
  ggplot(aes(x = sex, y = n)) + 
  geom_col() +
  coord_flip()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-2-3.png" width="672" />

In the code demonstrated above, I realize that all I am just changing is the name of the columns (`species`, `island`, `sex`) to create the three different plots. The rule of thumb is to avoid duplication of code; here we can attempt to create a function to shorten the number of lines written. We can create a function (I named it `geomcol_discrete`) with the nifty use of double brackets `{{ column }}` to utilize out tidyverse work flow: 


```r
# function - discrete plots
geomcol_discrete <- function(tbl, column) {
  tbl %>% 
    drop_na() %>% 
    count({{ column }}, sort = TRUE) %>% 
    mutate({{ column }} := fct_reorder({{ column }}, n)) %>% 
    ggplot(aes(x = {{ column }}, y = n)) + 
    geom_col() +
    coord_flip()
}

# now we quickly plot
penguins %>% geomcol_discrete(species)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-3-1.png" width="672" />

```r
penguins %>% geomcol_discrete(island)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-3-2.png" width="672" />

```r
penguins %>% geomcol_discrete(sex)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-3-3.png" width="672" />

I also created a function to plot histograms for the continuous data (`geomhist_continuous`):


```r
# function - continuous plots
geomhist_continuous <- function(tbl, column) {
  tbl %>% 
    drop_na() %>% 
    ggplot(aes(x = {{ column }}, fill = species)) +
    geom_histogram(alpha = 0.8)
}

# now we quickly plot
penguins %>% geomhist_continuous(bill_length_mm)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-4-1.png" width="672" />

```r
penguins %>% geomhist_continuous(bill_depth_mm)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-4-2.png" width="672" />

```r
penguins %>% geomhist_continuous(flipper_length_mm)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-4-3.png" width="672" />

```r
penguins %>% geomhist_continuous(body_mass_g)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-4-4.png" width="672" />

The next step further would be to create a vector of column names so that I can loop the functions. Stay tuned for a future update. As the Bay Area colloquially says, "We out here tryin' to function!"
