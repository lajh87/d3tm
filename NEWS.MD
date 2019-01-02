# d3RZoomableTreemap 0.2
## Major Changes
* Added d3_nest2 to convert data to a hierarchy that d3 expects

## Minor Changes
* Added parameters for breadcrumb help text
* Added parameter to enable custom number formating
* Updated events to include hover and clicked and data for id, label and value
* Fix bug where tibbles would not work with d3_nest2

# d3RZoomableTreemap 0.1
## Features
* Zoomable Treemap in [D3v5](https://d3js.org/) based on Mike Bostocks
  [zoomable treemap](https://bost.ocks.org/mike/treemap/). Only two levels of the 
  hierarchy are visible at a time. Mouseover to see child. Parent data does not 
  overflow
* Event clicks outputed to shiny.
* Custom rectangle colour either through adding `color` variable to data or 
  setting the `background` variable using an html colour name or the hexcode.
* Custom header colour.
* Responsive text colour, that will be either black or white depending on 
  background colour.
