## This script develops a map of population-weighted density at the census tract resolution,
## using block data to develop the measures.

library(sf)
library(ggplot2)
library(maps)
library(magrittr)
library(plyr)
library(dplyr)


## Current analysis uses
## + Ohio tract shapefiles, 2015 version, downloaded from https://www.census.gov/geo/maps-data/data/tiger-line.html
## + Ohio block shapefiles (but just the area land numbers), 2010 version, from NHGIS
## + Ohio block populations, 2010, from NHGIS
## + For the formula for population-weighted density, see https://www.census.gov/prod/cen2010/reports/c2010sr-01.pdf

ohio_tracts <- sf::st_read("./source_data/ohio_tracts_2015/tl_2015_39_tract.shp")
plot(st_geometry(ohio_tracts))

col_only <- subset(ohio_tracts, COUNTYFP == "049")
plot(st_geometry(col_only))

ohio_blocks <- sf::st_read("./source_data/ohio_blocks_2010/OH_block_2010.shp")
ohio_blocks <- ohio_blocks[,c("STATEFP10","COUNTYFP10","TRACTCE10","BLOCKCE10","GISJOIN","ALAND10")]
st_geometry(ohio_blocks) <- NULL

## Note that ALAND10 is the area land, reported in square meters. Shift to square miles.
ohio_blocks$ALAND10miles <- (ohio_blocks$ALAND10 / 1000000)*0.386102

ohio_blockpops <- read.csv("./source_data/ohio_blocks_2010/nhgis0061_ds172_2010_block.csv")
ohio_blockpops <- ohio_blockpops[,c("GISJOIN","H7V001")]
ohio_blockpops <- plyr::rename(ohio_blockpops, c("H7V001"="pop2010"))

ohio_blockmerged <- full_join(ohio_blocks, ohio_blockpops, by = "GISJOIN")
ohio_blockmerged$density_mi2 <- ohio_blockmerged$pop2010/ohio_blockmerged$ALAND10miles
ohio_blockmerged<- ohio_blockmerged[-which(is.na(ohio_blockmerged$density_mi2)), ]

ohio_blockmerged$popXdens <- ohio_blockmerged$pop2010 * ohio_blockmerged$density_mi2

ohio_blockmerged$tractid <- as.factor(paste0(as.character(ohio_blockmerged$STATEFP10), as.character(ohio_blockmerged$COUNTYFP10), as.character(ohio_blockmerged$TRACTCE10)))

ohio_trdens <- ohio_blockmerged %>% group_by(tractid) %>% summarize(sum(pop2010), sum(popXdens), sum(ALAND10miles))
ohio_trdens$wtd_dens <- ohio_trdens$`sum(popXdens)` / ohio_trdens$`sum(pop2010)`

summary(ohio_trdens)
tail(sort(ohio_trdens$wtd_dens),5)

arrange(ohio_trdens, desc(wtd_dens))

ohio_trdens <- plyr::rename(ohio_trdens, c("tractid"="GEOID"))
ohio_trfinal <- merge(ohio_tracts, ohio_trdens, by = "GEOID", all.x = TRUE, all.y = TRUE)

class(ohio_trfinal)

ohio_trfinal_trimmed <- ohio_trfinal[-which(ohio_trfinal$wtd_dens>100000), ]
ohio_trfinal_trimmed$lwdens <- log(ohio_trfinal_trimmed$wtd_dens)

plot(ohio_trfinal_trimmed["wtd_dens"])
plot(ohio_trfinal_trimmed["lwdens"])

col_only <- subset(ohio_trfinal_trimmed, COUNTYFP == "049")
summary(col_only)
plot(col_only["wtd_dens"])
plot(col_only["lwdens"])

