install.packages("ghit")
install.packages("devtools")
# 
# library("ghit")
# install_github("ropensci/EML", dependencies=c("Depends", "Imports"))

library(ghit)
# library(devtools)
library(EML)
dat <- data.frame(river = factor(c("SAC",  
                                   "SAC",   
                                   "AM")),
                  spp   = c("Oncorhynchus tshawytscha",  
                            "Oncorhynchus tshawytscha", 
                            "Oncorhynchus kisutch"),
                  stg   = ordered(c("smolt", 
                                    "parr", 
                                    "smolt"), 
                                  levels=c("parr", 
                                           "smolt")), # => parr < smolt
                  ct    = c(293L,    
                            410L,    
                            210L),
                  day   = as.Date(c("2013-09-01", 
                                    "2013-09-1", 
                                    "2013-09-02")),
                  stringsAsFactors = FALSE)
dat


col.defs <- c("River site used for collection",
              "Species scientific name",
              "Life Stage", 
              "count of live fish in traps",
              "The day on which traps were sampled")


unit.defs <- list(
  c(SAC = "The Sacramento River",     # Factor 
    AM = "The American River"),
  "Scientific name",                   # Character string 
  c(parr = "third life stage",        # Ordered factor 
    smolt = "fourth life stage"),
  c(unit = "number", 
    precision = 1, 
    bounds = c(0, Inf)),              # Integer
  c(format = "YYYY-MM-DD",            # Date
    precision = 1))

eml_write(dat, 
          col.defs = col.defs, 
          unit.defs = unit.defs, 
          creator = "Carl Boettiger <cboettig@ropensci.org>", 
          file = "EML_example.xml")

## practice csvy

library(gapminder)

write.csv(x = gapminder, file = "gapminder.csv", row.names = FALSE)

newgap <- read.csv("gapminder.csvy", skip = 21)

# install_githup("leeper/rio")

## data package manager
library(dpmr)

meta_list <- list(name = "gapminder_data",
                  title = "the data from Gapminder",
                  last_updated = "2016-02-25",
                  version = "0.1", 
                  license = "MIT")

datapackage_init(df = gapminder, meta = meta_list)


