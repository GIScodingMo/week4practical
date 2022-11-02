
library(here)
library(sf)
library(usethis)
library(countrycode)
library(dplyr)
library(janitor)

# 2. read files
#shapefile

map_data<-st_read(here::here('World_Countries_(Generalized)','World_Countries__Generalized_.shp'))

#csv file

ggi<-read.csv('HDR21-22_Composite_indices_complete_time_series.csv')

#3.select columns(2019,2010)
ggi1<-select(ggi,country, gii_2019, gii_2010,iso3)

#4. calculate difference
ggi1$dif<-ggi1$gii_2019-ggi1$gii_2010

#5. ggi change iso(country name)
# map data iso are two, but ggi are three
ggi2<-mutate(ggi1,iso2=countrycode(iso3, origin = 'iso3c', destination = 'iso2c'))

#6. join data
###why upper letter ISO doesn't work??????????
final<-map_data%>%
  clean_names()%>%
  left_join(.,ggi2,by=c("iso"="iso2"))

#7. show map
library(tmap)
library(tmaptools)
tmap_mode("plot")
qtm(final, 
    fill = "dif")