//var svg = d3.select("#circle").append("svg").attr("width", 200).attr("height", 200)

// Add the path using this helper function
svg.append('circle')
  .attr('cx', 100)
  .attr('cy', 100)
  .attr('r', 50)
  .attr('stroke', 'black')
  .attr('fill', '#69a3b2');

svg.append('text')
  .attr('x', 100)
  .attr('y', 50)
  .attr('stroke', 'green')
  .style("font-size", 19)
  .text("I'm another piece of text")
