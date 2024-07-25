
# D3 map ------------------------------------------------------------------


# Packages ----
library(r2d3maps)
library(rnaturalearth)


# Data ----
Togo <- ne_states(country = "Togo", returnclass = "sf")


# Map ----
r2d3map(
  data = Togo,
  script = "./my_map.js"
)
