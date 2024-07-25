# Sample data
data <- data.frame(
  category = c("A", "B", "C", "D", "E"),
  value = c(5, 10, 15, 20, 25)
)

# Save the data to a JSON file
# jsonlite::write_json(data, "barplot_example_data.json")

# Create the D3 plot using r2d3
r2d3(
  data = data,
  script = "chat_barplot_code.js",
  d3_version = "5",
  options = list(
    width = 500,
    height = 300
  ),
  css = "
    .bar {
      fill: steelblue;
    }
    .bar:hover {
      fill: orange;
    }
    .axis--x path {
      display: none;
    }
  "
)
