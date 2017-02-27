
library(dplyr)
library(EML)
library(gapminder)


# attributes --------------------------------------------------------------

attributes <- frame_data(
  ~attributeName, ~formatString,  ~definition       ,  ~unit, ~numberType, ~attributeDefinition,
  "country"     ,            NA,           "country",     NA,          NA,  "name of country",
  "continent"   ,            NA,         "continent",     NA,          NA,  "name of continent",
  "year"        ,        "YYYY",                  NA,     NA,          NA,  "year of sample",
  "lifeExp"     ,            NA,                  NA,     "number",   "real",  "life expentency at birth",
  "pop"         ,            NA,                  NA,     "number",   "real",  "total population",
  "gdpPercap"   ,            NA,                  NA,     "number",   "real",  "GDP per capita"
) 

## what units can we use? consult:
# standardUnits <- get_unitList()
# standardUnits$units
# View(standardUnits$units)


# factors -----------------------------------------------------------------

## there are no factors in this dataset, but this is where you would put them!

attributeList <- set_attributes(as.data.frame(attributes), 
                                col_classes = c("character", "character", 
                                                "Date",
                                                "numeric", "numeric", "numeric"))
## as many col_classes as there are rows in attributes
## note that you need to coerce attributes back to data.frame


# dataTable: putting it together ------------------------------------------



readr::write_csv(gapminder, "data/gapminder.csv")
physical <- set_physical("data/gapminder.csv")

dataTable <- new("dataTable",
                 entityName = "gapminder.csv",
                 entityDescription = "Gapminder data",
                 physical = physical,
                 attributeList = attributeList)


# person ------------------------------------------------------------------



R_person <- as.person("John Doe <john.doe@gmail.com")
ownername <-as(R_person, "creator")


contact <- 
  new("contact",
      individualName = ownername@individualName,
      electronicMail = ownername@electronicMailAddress,
      # address =,
      organizationName = "Gapminder",
      phone = "000-000-0000")



# coverage ----------------------------------------------------------------


coverage <- 
  set_coverage(begin = '1952-01-01', end = '2007-01-01',
               geographicDescription = "The world",
               west = -10, east = 70, 
               north = 90, south = -90,
               altitudeMin = 0, altitudeMaximum = 2000,
               altitudeUnits = "meter")


# combining everything: dataset -------------------------------------------


dataset <- new("dataset",
               title = "the title",
               creator = ownername,
               pubDate = "2016",
               coverage = coverage,
               contact = contact,
               dataTable = dataTable)

eml <- new("eml",
           packageId = "e2200f7b-1eea-426e-9be1-930671924e24",  # from uuid::UUIDgenerate(),
           system = "uuid", # type of identifier
           dataset = dataset)

eml_validate(eml)

write_eml(eml, file = "gapminder.eml")

eml_view("gapminder.eml")

