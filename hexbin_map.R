library(rnaturalearth)
library(sf)
library(tidyverse)
library(elevatr)
library(terra)

# Get polygon for the USA.
usa = ne_countries(country = 'united states of america')

usa = sf::st_as_sf(usa)

# Base a map of hexagons on USA polygon.
hexes = sf::st_as_sf(sf::st_make_grid(x = usa, n = c(50, 50), square = F))

hexes_centroid = sf::st_as_sf(sf::st_centroid(hexes))

# Get low-res elevation data across the USA, just to put some colour into the map.
el = elevatr::get_elev_raster(hexes, z = 2)

el = terra::rast(el)

el_mean = terra::extract(el, hexes, fun = mean)
el_max = terra::extract(el, hexes, fun = max)

hexes$el_mean = el_mean[,2]
hexes$el_max = el_max[,2]

g = ggplot() +
  geom_sf(data = hexes, aes(fill = el_max))

g

rayshader::plot_gg(g)

# Crop for USA polygon.
hexes_usa = hexes |> sf::st_filter(usa)

# Scale values so that min is 0.
hexes_usa$el = ifelse(hexes_usa$el < 0, 0, hexes_usa$el)

g = ggplot() +
  geom_sf(data = hexes_usa, aes(fill = el))

g

rayshader::plot_gg(g, offset_edges = 10,scale = 250)
