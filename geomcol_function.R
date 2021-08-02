library(tidyverse)
library(palmerpenguins)
theme_set(theme_minimal())

penguins

# function - discrete
geomcol_discrete <- function(tbl, column) {
  tbl %>% 
    drop_na() %>% 
    count({{ column }}, sort = TRUE) %>% 
    mutate({{ column }} := fct_reorder({{ column }}, n)) %>% 
    ggplot(aes(x = {{ column }}, y = n)) + 
    geom_col() +
    coord_flip()
}
# function - continuous
geomhist_continuous <- function(tbl, column) {
  tbl %>% 
    drop_na() %>% 
    ggplot(aes(x = {{ column }}, fill = species)) +
    geom_histogram(alpha = 0.8)
}

# slow way of plotting
penguins %>% 
  drop_na() %>% 
  count(species, sort = TRUE) %>% 
  mutate(species = fct_reorder(species, n)) %>% 
  ggplot(aes(x = species, y = n)) + 
  geom_col() +
  coord_flip()
penguins %>% 
  drop_na() %>% 
  count(island, sort = TRUE) %>% 
  mutate(island = fct_reorder(island, n)) %>% 
  ggplot(aes(x = island, y = n)) + 
  geom_col() +
  coord_flip()
penguins %>% 
  drop_na() %>% 
  count(sex, sort = TRUE) %>% 
  mutate(sex = fct_reorder(sex, n)) %>% 
  ggplot(aes(x = sex, y = n)) + 
  geom_col() +
  coord_flip()
penguins %>% 
  drop_na() %>% 
  ggplot(aes(x = species, y = bill_length_mm)) +
  geom_violin() +
  geom_boxplot(width = 0.25) +
  geom_point(alpha = 0.3) + 
  coord_flip()
penguins %>% 
  drop_na() %>% 
  ggplot(aes(x = bill_depth_mm, fill = species)) +
  geom_histogram(alpha = 0.8)
  
# or you can use our function to quickly plot
penguins %>% 
  geomcol_discrete(species)
penguins %>% 
  geomcol_discrete(island)
penguins %>% 
  geomcol_discrete(sex)

penguins %>% 
  geomhist_continuous(bill_length_mm)
penguins %>% 
  geomhist_continuous(bill_depth_mm)
penguins %>% 
  geomhist_continuous(flipper_length_mm)
penguins %>% 
  geomhist_continuous(body_mass_g)

penguins %>% 
  relocate(where(is.factor)) %>% 
  select(!year) %>% 
  drop_na() %>% 
  pivot_longer(4:7,
               names_to = "variable",
               values_to = "value") %>% 
  ggplot(aes(x = value, fill = species)) +
  geom_histogram(alpha = 0.8) +
  facet_wrap(~ variable, scales = "free")

