# Make some data.
library(r2d3)

# Tutorial: https://datatricks.co.uk/animated-d3-js-bar-chart-in-r

# d = data.frame(
#   time = c(1:30),
#   val = sample(x = c(1:10), size = 30, replace = T)
# )

d = data.frame(time=c(2011:2016),
               val=c(0.45, 0.47, 0.52, 0.7, 0.59, 0.47))

r2d3(
  data = d,
  options = list(margin = 50,
                 barPadding = 5,
                 colour = "red",
                 xLabel = "Time",
                 yLabel = "Value",
                 chartTitle = "Chart Title"),
  script = 'animated_bargraph.js',
  css = 'animated_bargraph.css',
  d3_version = '6'
)
