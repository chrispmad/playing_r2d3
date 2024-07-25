//var svg = d3.select("#circle").append("svg").attr("width", 200).attr("height", 200)

svg.selectAll('circle')
  .data(data)
  .enter().append('circle')
  .attr('x', data.lat)
  .attr('y', data.long)
  .attr('stroke', 'black');
