function draw(el, instance, resize){

  // Remove existing instances
  d3.select( el ).selectAll("*").remove();

  // if height or width = 0 then bail
  // (this is important for flexdashboard and tabsets)
  if(
    el.getBoundingClientRect().width === 0 ||
    el.getBoundingClientRect().height === 0
  ){
    return;
  }
  var data = instance.x.data;

  var margin = { top: 0, right: 0, bottom: 30.5, left: 0 },
  width = el.getBoundingClientRect().width - margin.left - margin.right,
  height = el.getBoundingClientRect().height - margin.top - margin.bottom;

  var svg = d3.select(el).style("position", "relative")
            .append("svg")
            .attr("viewBox", [0.5, -30.5, width, height + 30])
            .style("font", "10px sans-serif");

  // Adapted from https://observablehq.com/@d3/zoomable-treemap
  format = d3.format(",d")

  const x = d3.scaleLinear().rangeRound([0, width]);
  const y = d3.scaleLinear().rangeRound([0, height]);

  treemap = data => d3.treemap()
      .tile(tile)(d3.hierarchy(data)
      .sum(d => d.value)
      .eachBefore(function(d) { d.data.id = (d.parent ? d.parent.data.id + "-" : "") + d.data.name; })
      .sort((a, b) => b.value - a.value))

  var root = treemap(data);

  let group = svg.append("g")
      .call(render, root);

  if(resize) zoomin(instance.node);
  ztm_data_id_to_shiny_input(data, "id");

  Shiny.addCustomMessageHandler('zoom2node', function(node_id){
     zoomin(check_offspring(return_node(root, node_id, "id")));
     Shiny.onInputChange(el.id + '_clicked_id', node_id);
    })

  function render(group, root) {

    const node = group
      .selectAll("g")
      .data(root.children.concat(root))
      .join("g");

    node.attr("id", d => "node-"+d.data.id);

    node.append("title")
        .text(d => d.ancestors().reverse().map(d => d.data.name).join("/"));

    node.append("rect")
         .attr("id", d=>  d.data.id)
        .attr("fill", d => d === root ? "#fff" : d.children ? "#ccc" : "#ddd")
        .attr("stroke", "#fff")
        .attr("cursor", "pointer");

    node.append("clipPath")
        .attr("id", d=> "clip-" + d.data.id)
      .append("use")
       .attr("xlink:href", d => "#" + d.data.id);;

    node.append("text")
       .attr("clip-path", d => "url(#clip-"+d.data.id+")")
        .attr("font-weight", d => d === root ? "bold" : null)
      .selectAll("tspan")
      .data(d => (d === root ? d.ancestors().reverse().map(d => d.data.name).join("/") : d.data.name)
                  .split(/(?=[A-Z][^A-Z])/g).concat(format(d.value)))
      .join("tspan")
        .attr("x", 3)
        .attr("y", (d, i, nodes) => `${(i === nodes.length - 1) * 0.3 + 1.1 + i * 0.9}em`)
        .attr("fill-opacity", (d, i, nodes) => i === nodes.length - 1 ? 0.7 : null)
        .attr("font-weight", (d, i, nodes) => i === nodes.length - 1 ? "normal" : null)
        .text(d => d);

    node.on("mouseover", (event, d) => mouseover_to_shiny_input(d))
        .on("mouseout", (event, d) => mouseout_to_shiny_input(d))
        .on("click", (event, d) => d === root ? zoomout(root) : zoomin(d))

    children_to_shiny_input(node, root);
    group.call(position, root);
  }

  function position(group, root) {
    group.selectAll("g")
        .attr("transform", d => d === root ? `translate(0,-30)` : `translate(${x(d.x0)},${y(d.y0)})`)
      .select("rect")
        .attr("width", d => d === root ? width : x(d.x1) - x(d.x0))
        .attr("height", d => d === root ? 30 : y(d.y1) - y(d.y0));
  }

  // When zooming in, draw the new nodes on top, and fade them in.
  function zoomin(d) {

    click_to_shiny_input(d);

    if(d.children === undefined) return undefined;
    instance.node = d;

    const group0 = group.attr("pointer-events", "none");
    const group1 = group = svg.append("g").call(render, d);

    x.domain([d.x0, d.x1]);
    y.domain([d.y0, d.y1]);

    svg.transition()
        .duration(750)
        .call(t => group0.transition(t).remove()
          .call(position, d.parent))
        .call(t => group1.transition(t)
          .attrTween("opacity", () => d3.interpolate(0, 1))
          .call(position, d));
  }

  // When zooming out, draw the old nodes on top, and fade them out.
  function zoomout(d) {

    click_to_shiny_input(d.parent);

    if(d.parent === null) return null;

    instance.node = d;

    const group0 = group.attr("pointer-events", "none");
    const group1 = group = svg.insert("g", "*").call(render, d.parent);

    x.domain([d.parent.x0, d.parent.x1]);
    y.domain([d.parent.y0, d.parent.y1]);

    svg.transition()
        .duration(750)
        .call(t => group0.transition(t).remove()
          .attrTween("opacity", () => d3.interpolate(1, 0))
          .call(position, d))
        .call(t => group1.transition(t)
          .call(position, d.parent));
  }

  function tile(node, x0, y0, x1, y1) {
    d3.treemapBinary(node, 0, 0, width, height);
    for (const child of node.children) {
      child.x0 = x0 + child.x0 / width * (x1 - x0);
      child.x1 = x0 + child.x1 / width * (x1 - x0);
      child.y0 = y0 + child.y0 / height * (y1 - y0);
      child.y1 = y0 + child.y1 / height * (y1 - y0);
    }
  }

  function click_to_shiny_input(d){
    if( HTMLWidgets.shinyMode ){
      Shiny.onInputChange(el.id + '_clicked_id', d.data.id);
      Shiny.onInputChange(el.id + '_clicked_depth', d.depth);
      }
    }

  function mouseover_to_shiny_input(d){
    if( HTMLWidgets.shinyMode ){
      Shiny.onInputChange(el.id + '_mouseover_id', d.data.id);
      Shiny.onInputChange(el.id + '_mouseover_depth', d.depth);
      Shiny.onInputChange(el.id + '_mouseover_parent_id', d.parent.data.id);
      }
    }

  function mouseout_to_shiny_input(d){
    if( HTMLWidgets.shinyMode ){
      Shiny.onInputChange(el.id + '_mouseover_id', null);
      Shiny.onInputChange(el.id + '_mouseover_depth', null);
      }
    }

  function children_to_shiny_input(node, root){
    const childrenArray = [];
    node.data().forEach(d => d !== root ? childrenArray.push(d.data.id) : null);

    if( HTMLWidgets.shinyMode ){
      Shiny.onInputChange(el.id + '_children', childrenArray);
      }
    }

   function ztm_data_id_to_shiny_input(root){
     const data_ids = return_key_value(root, "id");
     if( HTMLWidgets.shinyMode ){
      Shiny.onInputChange(el.id + '_data_ids', data_ids);
      }
    }

 function return_key_value(obj, key) {
    var values = [];

    function extract_key_value(obj, key){
        values.push(obj[key]);
        if(obj.children)
            obj.children.forEach(child => {extract_key_value(child, key)})
    }

    extract_key_value(obj, key);

    return values;

  }


  // return a obj from nested json if a key is equal to a specified value
  function return_node(obj, value, key) {
    if (obj.data[key] === value) {
        return obj;
    } else {
        if (obj.children) {
            for (var i in obj.children) {
                const node = return_node(obj.children[i], value, key);
                if (node) return node;
            }
        }
    }
  }

  function check_offspring(node){
    if(!node.children){
        return node.parent;
    } else
    return node;
}

  return instance;

}
