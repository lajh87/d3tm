HTMLWidgets.widget({

  name: "d3v5_zoomable_treemap",

  type: "output",

  factory: function(el, width, height) {

    var instance = { };

    var el = el;

    d3.formatDefaultLocale(
      {
        "decimal": ".",
        "thousands": ",",
        "grouping": [3],
        "currency": ["£", ""],
        "dateTime": "%a %b %e %X %Y",
        "date": "%m/%d/%Y",
        "time": "%H:%M:%S",
        "periods": ["AM", "PM"],
        "days": ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
        "shortDays": ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
        "months": ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
        "shortMonths": ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
      }
    );
  if( HTMLWidgets.shinyMode ){
    Shiny.addCustomMessageHandler('resetInputValue',
                function(variableName){
                  Shiny.onInputChange(variableName, null);
                  });
  }

  var draw = function(el, instance){

    var xR = instance.x;
    d3.select( el ).selectAll("*").remove();

    // if height or width = 0 then bail
    //   this is important for flexdashboard and tabsets
    if(
      el.getBoundingClientRect().width === 0 ||
      el.getBoundingClientRect().height === 0
    ){
      return;
    }

    var root = d3.hierarchy(xR.data);

    var margin = {top: xR.header_height, right: 0, bottom: 0, left: 0},
        width = el.getBoundingClientRect().width,
        height = el.getBoundingClientRect().height - margin.top - margin.bottom,
        formatNumber = d3.format(xR.format_string),
        transitioning;

    // sets x and y scale to determine size of visible boxes
    var x = d3.scaleLinear()
        .domain([0, width])
        .range([0, width]);

    var y = d3.scaleLinear()
        .domain([0, height])
        .range([0, height]);

    var treemap = d3.treemap()
            .size([width, height])
            .paddingInner(0)
            .round(false);

    // create div tooltip to enable html text
    var tooltip = d3.select(el).append("div")
                    .attr("class","tooltip")
                    .style("opacity", 0)
                    .style("background", xR.tooltip_background)
                    .style("color", idealTextColor(xR.tooltip_background))
                    .style("width", "200px")
                    .style("height", "75px");

    function mouseover() {
      tooltip.style("display", "inline");
    }

    var tooltip_bb = tooltip.node().getBoundingClientRect() ;


    function mousemove() {

      var rect = this.getBoundingClientRect();

      // hacky fix for wierd rmarkdown behaviour
      if(xR.rmarkdown){
       var
        ox = d3.mouse(this)[0],
         oy = d3.mouse(this)[1] + rect.height;
      } else{
        var
         ox = d3.mouse(this)[0],
         oy = d3.mouse(this)[1];
      }

      if(d3.mouse(this)[0]  > ( rect.width - tooltip_bb.width * 2)){
        var ox = ox - tooltip_bb.width;
      }

      if(d3.mouse(this)[1] > (rect.height - tooltip_bb.height*2)){
        var oy = oy - tooltip_bb.height;
      }

      tooltip
      .style("left", (ox) + 25 + "px")
      .style("top", (oy) - 25 + "px");
       }

    function mouseout() {
      tooltip.style("display", "none");
    }

    var svg = d3.select(el).append("svg")
        .attr("width", width + margin.left + margin.right)
                    .attr("height", height + margin.bottom + margin.top)
                    .style("margin-left", -margin.left + "px")
                    .style("margin.right", -margin.right + "px")
                    .append("g")
                    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
                    .style("shape-rendering", "crispEdges")
                    .on("mouseover", mouseover)
                    .on("mousemove", mousemove)
                    .on("mouseout", mouseout);

    var grandparent = svg.append("g")
            .attr("class", "grandparent");

        grandparent.append("rect")
            .attr("y", -margin.top)
            .attr("width", width)
            .attr("height", margin.top);

        grandparent.append("text")
            .attr("x", 6)
            .attr("y", 6 - margin.top)
            .attr("dy", ".75em");

        grandparent.append("foreignObject")
            .attr("x", 0)
            .attr("y", - margin.top)
            .attr("dy", ".75em")
            .attr("width", width)
            .attr("height", margin.top)
            .attr("dy", ".75em")
            .attr("class", "foreignobj")
            .append("xhtml:div")
            .attr("class", "headertextdiv")
            .style("color", idealTextColor(xR.header_background))
            .style("font-size", xR.header_fontsize)
            .style("height", xR.header_height + "px");

        treemap(root
            .sum(function (d) {
                return d.value;
            })
            .sort(function (a, b) {
                return b.height - a.height || b.value - a.value;
            })
        );

        display(root);

        function display(d) {

           // write text into grandparent
            // and activate click's handler
            grandparent
                .datum(d.parent)
                .on("click", function(d){
                    transition(d);
                    click_to_shiny_input(d);
                })
                .on("mouseover", function(d){
                    hover_to_shiny_input(d);
                    })
                .on("mouseout", mouseout_to_shiny_input);

            // grandparent color
            grandparent
                .datum(d.parent)
                .select("rect")
                .attr("fill", function () {
                    return xR.header_background;
                });

             grandparent
               .select(".headertextdiv")
               .html(function () {
                   return '' +
                      '<p class="title"> ' + name(d) + '</p>'
                   ;
               });

            var g1 = svg.insert("g", ".grandparent")
                .datum(d)
                .attr("class", "depth");

            var g = g1.selectAll("g")
                .data(d.children)
                .enter().
                append("g");

                 // add class and click handler to all g's with children
                g.filter(function (d) {return d.children;})
                 .classed("children", true)
                 .on("click", function(d){
                     transition(d);
                     click_to_shiny_input(d);
                 });

               g.selectAll(".child")
                .data(function (d) {
                    return d.children || [d];
                })
                .enter().append("g")
                .append("rect")
                  .attr("class", "child")
                  .call(rect);

              g.selectAll(".child")
                .on("mouseover", function(d) {
                     var tooltip_child = d.data.name;
                         tooltip_parent = d.parent.data.name;
                         tooltip_child_value = formatNumber(d.value).replace(/G/,"B");
                         tooltip_parent_value = formatNumber(d.parent.value).replace(/G/,"B");
                         parent_name = d.parent.data.col_name ? d.parent.data.col_name + ": " : "";
                         child_name = d.data.col_name ? d.data.col_name + ": " : "";
                     tooltip
                       .html(function(d) {
                       return  parent_name + "<b>" + tooltip_parent + "</b><br>" +
                               child_name + "<b>" + tooltip_child  + "</b><br>" +
                               "value: <b>" + tooltip_child_value + "</b>";
                       })
                      .style("opacity", 0.9);
                     })
                 .on("mouseout", function(d) {
                     tooltip.style("opacity", 0);
                     });

                // add title to parents
              g.append("rect")
                .attr("class", "parent")
                .attr("id", function(d) { return d.data.key; })
                .call(rect);

                /* Adding a foreign object instead of a text object, allows for text wrapping */
                g.append("foreignObject")
                .call(rect)
                .attr("class", "foreignobj")
                .style("pointer-events", "none")
                .append("xhtml:div")
                .attr("dy", ".75em")
                .html(function (d) {
                    return '' +
                        '<font color = ' +idealTextColor(d.data.color ? d.data.color : xR.background) + '>' +
                        '<p class="title"> ' + d.data.name + '</p>' +
                        '<p>' + formatNumber(d.value).replace(/G/,"B") + '</p>' +
                        '</font>'
                    ;
                })
                .attr("class", "textdiv"); //textdiv class allows us to style the text easily with CSS


            function transition(d) {
                if (transitioning || !d) return;
                transitioning = true;
                var g2 = display(d),
                    t1 = g1.transition().duration(650),
                    t2 = g2.transition().duration(650);
                // Update the domain only after entering new elements.
                x.domain([d.x0, d.x1]);
                y.domain([d.y0, d.y1]);

                // Enable anti-aliasing during the transition.
                svg.style("shape-rendering", null);
                // Draw child nodes on top of parent nodes.
                svg.selectAll(".depth").sort(function (a, b) {
                    return a.depth - b.depth;
                });

                 // Update Grandparent
                grandparent
                  .select(".headertextdiv")
                  .html(function () {
                   return '' +
                      '<p class="title"> ' + name(d) + '</p>'
                   ;
                  });

                // Fade-in entering text.
                g2.selectAll("text").style("fill-opacity", 0);
                g2.selectAll("foreignObject div").style("display", "none");

                // Transition to the new view.
                t1.selectAll("text").call(text).style("fill-opacity", 0);
                t2.selectAll("text").call(text).style("fill-opacity", 1);
                t1.selectAll("rect").call(rect);
                t2.selectAll("rect").call(rect);
                t1.selectAll(".textdiv").style("display", "none");
                t1.selectAll(".foreignobj").call(foreign);
                t2.selectAll(".textdiv").style("display", "block");
                t2.selectAll(".headertextdiv").style("display", "block");
                t2.selectAll(".foreignobj").call(foreign);

                // Remove the old node when the transition is finished.
                t1.on("end.remove", function(){
                    this.remove();
                    transitioning = false;
                });
            }
            return g;
        }

        function click_to_shiny_input(d){
           // add a hook to Shiny
          if( HTMLWidgets.shinyMode ){
            Shiny.onInputChange(el.id + '_clicked_id', d.data.key);
            Shiny.onInputChange(el.id + '_clicked_label', d.data.name);
            Shiny.onInputChange(el.id + '_clicked_depth', d.depth);
            }
          }

          function hover_to_shiny_input(d){
          if( HTMLWidgets.shinyMode ){
            Shiny.onInputChange(el.id + '_hover_id', d.data.key);
            Shiny.onInputChange(el.id + '_hover_label', d.data.name);
            Shiny.onInputChange(el.id + '_hover_depth', d.depth);
            }
          }

          function mouseout_to_shiny_input(df){
            if( HTMLWidgets.shinyMode ){
            Shiny.onInputChange(el.id + '_hover_id', null);
            Shiny.onInputChange(el.id + '_hover_label', null);
            Shiny.onInputChange(el.id + '_hover_depth', null);
            }
          }

          function getContrast50(hexcolor){
              return (parseInt(hexcolor.replace('#', ''), 16) > 0xffffff/3) ? 'black':'white';
          }

          function getRGBComponents(color) {
              return d3.rgb(color);
          }

          function idealTextColor(bgColor) {
              var nThreshold = 105;
              var components = getRGBComponents(bgColor);
              var bgDelta = (components.r * 0.299) + (components.g * 0.587) + (components.b * 0.114);
              return ((255 - bgDelta) < nThreshold) ? "#000000" : "#ffffff";
           }

        function text(text) {
           text.attr("x", function (d) {return x(d.x) + 6;})
                .attr("y", function (d) {return y(d.y) + 6;})
         }

        function rect(rect) {
            rect
                .attr("x", function (d) {
                    return x(d.x0);
                })
                .attr("y", function (d) {
                    return y(d.y0);
                })
                .attr("width", function (d) {
                    return x(d.x1) - x(d.x0);
                })
                .attr("height", function (d) {
                    return y(d.y1) - y(d.y0);
                })
                .attr("fill", function (d) {
                    return d.data.color ? d.data.color : xR.background;
                });
        }

        function foreign(foreign) { /* added */
            foreign
                .attr("x", function (d) {
                    return x(d.x0);
                })
                .attr("y", function (d) {
                    return y(d.y0);
                })
                .attr("width", function (d) {
                    return x(d.x1) - x(d.x0);
                })
                .attr("height", function (d) {
                    return y(d.y1) - y(d.y0);
                });
        }

        function name(d) {
            return breadcrumbs(d) +
                (d.parent
                ? xR.zoom_out_helptext
                : xR.zoom_in_helptext);
        }

        function breadcrumbs(d) {
            var res = "";
            var sep = " > ";
            d.ancestors().reverse().forEach(function(i){
                res += i.data.name + " (" + formatNumber(i.value).replace(/G/,"B") + ")" + sep;
            });
            return res
                .split(sep)
                .filter(function(i){
                    return i!== "";
                })
                .join(sep);
        }

        return instance;
  };



    return {
      renderValue: function(x) {

        instance.x = x;
        instance = draw(el, instance);

      },

      resize: function(width, height) {
        instance = draw(el, instance);
      },

      instance: instance

    };
  }
});
