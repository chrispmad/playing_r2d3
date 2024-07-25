
// Set up some static values
var dat_x = 50,
  margin = options.margin,
  barPadding = options.barPadding,
  width = width-(2*margin),
  height = height-(2*margin),
  barWidth = Math.floor(width/data.length - barPadding),
  xmax = d3.max(data, function(d) { return d.time; }),
  xmin = d3.min(data, function(d) { return d.time; }),
  ymax = d3.max(data, function(d) { return d.val; });

// Make X axis
 var x = d3.scaleBand()
        .domain(data.map(function(d) { return d.time; }))
        .range([0, width-barPadding]);

svg.append('g')
 .attr('transform', 'translate(' + margin + ',' + (height+margin) + ')')
 .call(d3.axisBottom(x));

svg.append('text')
  .attr('transform', 'translate(' + (width/2) + ' ,' + (height+2*margin) + ')')
  .attr('dx', '1em')
  .style('text-anchor', 'middle')
  .style('font-family', 'Tahoma, Geneva, sans-serif')
  .style('font-size', '12pt')
  .text(options.xLabel);

//Create the y axis
var y = d3.scaleLinear()
        .range([height, 0])
        .domain([0, ymax]);
svg.append('g')
.attr('transform', 'translate(' + margin + ', ' + margin + ')')
.call(d3.axisLeft(y));
svg.append('text')
.attr('transform', 'translate(' + 0 + ' ,' + ((height+2*margin)/2) + ') rotate(-90)')
.attr('dy', '1em')
.style('text-anchor', 'middle')
.style('font-family', 'Tahoma, Geneva, sans-serif')
.style('font-size', '12pt')
.text(options.yLabel);

//Create the chart title
svg.append('text')
.attr('x', (width / 2))
.attr('y', (margin/2))
.attr('text-anchor', 'middle')
.attr('dx', '1em')
.style('font-size', '16pt')
.style('font-family', 'Tahoma, Geneva, sans-serif')
.text(options.chartTitle);

// Append a container for our bars. This is optional, but allows
// for glowing bars, which is nice...
var bar_container = svg.append('g')
  .attr('class','funbar-container')
  .attr('width', width)
  .attr('height', height);

// Add rectangles for each x axis value, appending to our bar container div.

// We'll need 3 rectanges for each x axis value:
// 1. The fuzzy glow layer at the very back
// 2. The behindbar that gives the bar a
bar_container.selectAll('rect')
//svg.selectAll('rect')
  .data(data)
  .enter()
  .append('rect')
  .attr('height', function(d) { return d.val/ymax * height; })
  .attr('width', barWidth-barPadding)
  //.attr('width', function(d, i) { return barWidth-i*barPadding; })
  .attr('class', 'funbar')
  .attr('x', function(d, i) { return (margin+((i+0.5)*barPadding)+(i*barWidth));
  })
//.attr('y', function(d) { return (height+margin-(d.val/ymax * height)); })
.attr('y', height + margin)
.attr('fill', options.colour)
.style('opacity', 0);

svg.selectAll('rect')
  .transition()
  .delay(function(d,i){return (i*100);})
  .duration(function(d,i){return (1000+(i*200));})
  .style('opacity', 1)
  .attr('height', function(d) { return d.val/ymax * height; })
  .attr('y', function(d) { return (height+margin-(d.val/ymax * height)); });

// Attempting to add a div to each rect...
svg.selectAll('rect')
  .append('div')
  .attr('class','styled-bar-border');

  //Create a tooltip
var Tooltip = d3.select('#htmlwidget_container')
  .append('div')
  .attr('class', 'tooltip')
  .attr('id', 'my_tooltip')
  .style('position', 'absolute')
  //.style('height', '40px')
  //.style('width', '100px')
  .style('top', '100px')
  .style('left', '100px')
  .style('background-color', 'rgba(255,255,255,0.8)')
  .style('border-radius', '5px')
  .style('padding', '5px')
  .style('opacity', 0)
  .style('font-family', 'Tahoma, Geneva, sans-serif')
  .style('font-size', '12pt');

  //Mouseover effects for tooltip

  var mouseover = function(d) {

    torp = d3.select(this);

    boop = 'Year ' + torp.data()[0].time + ': ' + torp.data()[0].val;

    Tooltip
      .html(boop)
      .style('opacity', 1)
      .style('box-shadow', '5px 5px 5px rgba(0,0,0,0.2)');

    d3.select(this)
      .attr('class', 'hovered-bar');
      //.attr('class', 'hovered-bar');
      //.style('transform', 'scaleX(120%) translateX(-20%)')
      //.style('transform', 'scaleY(120%) translateY(-20%)')
      //.attr('fill', 'rgba(100,0,0,1)');
};
var mousemove = function(d) {
  Tooltip
    //.html('Year ' + d.time + ': ' + d.val);
    .style('left', (d.clientX+10) + 'px')
    .style('top', (d.clientY+10) + 'px');
};
var mouseleave = function(d) {
  //d3.select('tooltip')

  // Set tooltip to be invisible again.
  Tooltip
      .style('opacity', 0);

  // Return initial colour to highlighted bar.
  d3.select(this)
    .attr('class','styled-bar')
    //.style('transform', 'scaleX(100%)')
    //.style('transform', 'scaleY(100%)')
    .attr('fill', options.colour);
};

svg.selectAll('rect')
  .on('mouseover', mouseover)
  .on('mousemove', mousemove)
  .on('mouseleave', mouseleave);
