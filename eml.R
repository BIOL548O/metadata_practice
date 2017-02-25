library("EML")
f <- system.file("xsd/test/eml-i18n.xml", package = "EML")
eml_view(f)

library(dplyr)

## could also be done:
attributes_df <- frame_data(
  ~attributeName, ~formatString,  ~definition       ,  ~unit, ~numberType, ~attributeDefinition,
  "run.num"     ,            NA,  "which run number",     NA,          NA,  "which run number (=block). Range: 1 - 6. (integer)",
  "year"        ,        "YYYY",                  NA,     NA,          NA,  "year, 2012",
  "day"         ,         "DDD",                  NA,     NA,          NA,  "Julian day. Range: 170 - 209. ",
  "hour.min"    ,        "hhmm",                  NA,     NA,          NA,  "hour and minute of observation. Range 1 - 2400 (integer)",
  "i.flag"      ,            NA,                  NA,     NA,          NA,  "is variable Real, Interpolated or Bad (character/factor)",
  "variable"    ,            NA,                  NA,     NA,          NA,  "what variable being measured in what treatment (character/factor).",
  "value.i"     ,            NA,                  NA,     NA,          NA,  "value of measured variable for run.num on year/day/hour.min.",
  "length"      ,            NA,                  NA,     "meter",  "real",  "length of the species in meters (dummy example of numeric data) "
)

## now for the factors:

i.flag <- frame_data(
  ~attributeName, ~code,  ~definition,
  "i.flag",       "R",    "real",
  "i.flag",       "I",    "interpolated",
  "i.flag",       "B",    "bad"
)

variable <- frame_data(
  ~code,       ~definition,
  "control"    , "no prey added",
  "low"        , "0.125 mg prey added ml-1 d-1",
  "med.low"    , "0,25 mg prey added ml-1 d-1",
  "med.high"   , "0.5 mg prey added ml-1 d-1",
  "high"       , "1.0 mg prey added ml-1 d-1",
  "air.temp"   , "air temperature measured just above all plants (1 thermocouple)",
  "water.temp" , "water temperature measured within each pitcher",
  "par"        , "photosynthetic active radiation (PAR) measured just above all plants (1 sensor)"
) %>% 
  mutate(attributeName = "variable")

value.i <- frame_data(
 ~code         , ~definition         ,  
  "control"    , "% dissolved oxygen",
  "low"        , "% dissolved oxygen",
  "med.low"    , "% dissolved oxygen",
  "med.high"   , "% dissolved oxygen",
  "high"       , "% dissolved oxygen",
  "air.temp"   , "degrees C"         ,
  "water.temp" , "degrees C"         ,
  "par"        , "micromoles m-1 s-1"
) %>% 
  mutate(attributeName = "value.i")

factors <- bind_rows(value.i, variable, i.flag)

attributeList <- set_attributes(as.data.frame(attributes_df), 
                                as.data.frame(factors), 
                                col_classes = c("character", "Date", "Date", 
                                                "Date", "factor", "factor", 
                                                "factor", "numeric"))
## as many col_classes as there are rows in attributes
## note that you need to coerce attributes back to data.frame

glimpse(attributes)

physical <- set_physical("hf205-01-TPexp1.csv")

dataTable <- new("dataTable",
                 entityName = "hf205-01-TPexp1.csv",
                 entityDescription = "tipping point experiment 1",
                 physical = physical,
                 attributeList = attributeList)

R_person <- as.person("Aaron Ellison <fakeaddress@email.com>")
aaron <-as(R_person, "creator")


coverage <- 
  set_coverage(begin = '2012-06-01', end = '2013-12-31',
               sci_names = "Sarracenia purpurea",
               geographicDescription = "the ocean",
               west = -122.44, east = -117.15, 
               north = 37.38, south = 30.00,
               altitudeMin = 160, altitudeMaximum = 330,
               altitudeUnits = "meter")



HF_address <- new("address",
                  deliveryPoint = "324 North Main Street",
                  city = "Petersham",
                  administrativeArea = "MA",
                  postalCode = "01366",
                  country = "USA")

contact <- 
  new("contact",
      individualName = aaron@individualName,
      electronicMail = aaron@electronicMailAddress,
      address = HF_address,
      organizationName = "Harvard Forest",
      phone = "000-000-0000")


dataset <- new("dataset",
               title = "the title",
               creator = aaron,
               pubDate = "2016",
               coverage = coverage,
               contact = contact,
               dataTable = dataTable)

eml <- new("eml",
           packageId = "e2200f7b-1eea-426e-9be1-930671924e24",  # from uuid::UUIDgenerate(),
           system = "uuid", # type of identifier
           dataset = dataset)

eml_validate(eml)
