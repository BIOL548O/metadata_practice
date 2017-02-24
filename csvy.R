library(gapminder)
library(dplyr)
library(readr)
library(csvy)

write_csv(gapminder, path = "data/gapminder_metadata.csvy")

read_csv("data/gapminder_metadata.csvy")

gapminder_after <- read_csvy("data/gapminder_metadata.csvy")
glimpse(gapminder_after)
head(gapminder_after)
str(gapminder_after)

# comment! this is a comment!
gap1 <- read.csv("data/gapminder_metadata.csvy", comment.char = "#")
glimpse(gap1)


write_csvy(gapminder, file = "data/gapminder_meta_write.csvy")

## example of writing metadata in R
gapminder %>% 
  mutate(country = as.character(country),
         country = `attr<-`(country, "description",
                            "Name of the country")) %>% 
  write_csvy(file = "data/gapminder_meta_write.csvy")

## another way

gapminder_chr_country <- gapminder %>% 
  mutate(country = as.character(country))
         
attr(gapminder_chr_country$country, which = "title") <- "Country name" 

gapminder_chr_country %>% 
  write_csvy("data/gapminder_meta_write.csvy")

