library(bcdata)
library(bcmaps)
library(sf)
library(r2d3)
library(r2d3maps)
library(leaflet)
library(tigris)
library(rnaturalearth)
library(tidyverse)

options(tigris_use_cache = TRUE)

counties_r = rnaturalearth::ne_states(country = 'united states of america')
counties_r = sf::st_as_sf(counties_r)

counties = tigris::counties(cb = T)

counties = sf::st_simplify(counties)

qd = r2d3::as_d3_data(quakes)

qsf = st_as_sf(qd, coords = c("long","lat"), crs = 4326)

r2d3(
  data = c(0.3, 0.6, 0.8, 0.95, 0.40, 0.20),
  script = system.file("examples/barchart.js", package = "r2d3")
)

readLines(system.file("examples/barchart.js", package = "r2d3"))

r2d3(
  data = qd,
  script = 'd3_map_fig.js'
)


r2d3(
  data = data.frame(x = 100),
  script =
"
var dat_x = data[0].x;

svg.append('text')
  .attr('x', dat_x)
  .attr('y', 50)
  .attr('stroke', 'green')
  .style('font-size', 19)
  .style('z-index', 10)
  .text('Im a piece of text');

svg.append('circle')
  .attr('cx', 100)
  .attr('cy', 100)
  .attr('r', dat_x)
  .attr('stroke', 'black')
  .style('z-index', -10)
  .attr('fill', '#69a3b2');
"
)

r2d3(
  data = iris,
  script = 'circle_test.js'
)


# Make a map of Canada
library(canadianmaps)
library(geojsonsf)
library(geojsonio)

provs = PROV |>
  dplyr::select(name = PRENAME) |>
  sf::st_transform(3005)

ggplot() + geom_sf(data = provs)

# provs_g = geojsonio::geojson_json(provs)

provs_g = sf_geojson(provs)

# provs_topo <- geojsonio::geo2topo(x = provs_g, object_name = "states")

# test_dat = jsonlite::read_json("https://raw.githubusercontent.com/holtzy/D3-graph-gallery/master/DATA/world.geojson")

test_dat = geojsonio::geojson_read("https://raw.githubusercontent.com/holtzy/D3-graph-gallery/master/DATA/world.geojson")

# ggplot() + geom_sf(data = test_dat)
# geojson_sf(test_dat)

r2d3(
  data = test_dat,
  script =
    '
  // Set up map and its projection
  var projection = d3.geoNaturalEarth1()
    .scale(width / 1.75 / Math.PI)
    .translate([width / 2, height / 2])

  // Draw the map
  svg.append("g")
    .selectAll("path")
    .data(data.features)
    .enter().append("path")
        .attr("fill", "#69b3a2")
        .attr("d", d3.geoPath()
            .projection(projection)
        )
        .style("stroke", "#fff")
'
)

# Data ----
Togo <- ne_states(country = "Togo", returnclass = "sf")


# Map ----
r2d3map(
  data = Togo,
  script = "./my_map.js",
  d3_version = "6"
)

library(zipcodeR)
library(tidyverse)

county_info = zipcodeR::zip_code_db |>
  as_tibble() |>
  dplyr::select(NAMELSAD = county,population:median_household_income) |>
  dplyr::group_by(NAMELSAD) |>
  dplyr::summarise(dplyr::across(everything(), \(x) mean(x,na.rm=T)))

cties = counties |>
  dplyr::left_join(county_info)



# map data
fr_dept <- ne_states(country = "france", returnclass = "sf")
fr_dept <- fr_dept[fr_dept$type_en %in% "Metropolitan department", ]

# firstnames data
data("prenoms_fr", package = "r2d3maps")

prenoms_fr_89 <- prenoms_fr %>%
  filter(annais == 1989, sexe == 2) %>%
  group_by(preusuel) %>%
  mutate(n = n()) %>%
  ungroup() %>%
  mutate(prenom = if_else(n < 2, "AUTRE", preusuel))

fr_dept <- left_join(
  x = fr_dept,
  y = prenoms_fr_89,
  by = "adm1_code"
)

# draw map
d3_map(shape = fr_dept) %>%
  add_discrete_scale(
    var = "prenom", palette = "Set2",
    labels_order = c(setdiff(unique(na.omit(fr_dept$prenom)), "AUTRE"), "AUTRE")
  ) %>%
  add_tooltip(value = "<b>{name}</b>: {prenom}", .na = NULL) %>%
  # add_legend(title = "Prénoms") %>%
  add_labs(
    title = "Prénoms féminins les plus attribués en 1989",
    caption = "Data: Insee"
  )
