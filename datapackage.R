# library(devtools)
# install_github("ropenscilabs/datapkg")


# writing a datapackage ---------------------------------------------------


library(datapkg)
library(gapminder)
datapkg_write(gapminder, path = "gapminder_datapackage/", name = "The Gapminder Data")


# reading a datapackage ---------------------------------------------------


gapminder_dpkg <- datapkg_read("gapminder_datapackage/")
str(gapminder_dpkg)

gapminder_dpkg$data$`The Gapminder Data`


# multiple files ----------------------------------------------------------

continent_sizes <- read.csv("continents.csv")
continent_sizes
datapkg_write(continent_sizes, path = "gapminder_datapackage/")

## reading it back in
gapminder_dpkg <- datapkg_read("gapminder_datapackage/")
str(gapminder_dpkg)
gapminder_dpkg$data$`The Gapminder Data`
gapminder_dpkg$data$continent_sizes
