# d3Rtm 0.3
## Major Changes
* Rename from d3RZoomableTreemap to d3tm [(d480b3)](https://gitlab.com/lajh87/d3tm/commit/d480b3f42f029ea9c58fa83b1ab2a43054ee8a5d")

## Bug Fixes
* Fixed issue when rendering in a div that had style position equal to relative
[(89cca7)](https://gitlab.com/lajh87/d3tm/commit/89cca7ae3ac7a35ea0010493f95c2e8a18464ae2)

# d3RZoomableTreemap 0.2.1
## Bug Fixes (#a16ac5b)
* Fixed shiny hover inputs
* Fixed tooltip bounding so it does not overflow container.
* Ammended documentation

# d3RZoomableTreemap 0.2
## Major Changes
* Added d3_nest2 to convert data to a hierarchy that d3 expects
* Added tooltip to treemap that consider col_name (60a8a2)

## Minor Changes
* Added parameters for breadcrumb help text
* Added parameter to enable custom number formating
* Updated events to include hover and clicked and data for id, label and value
* Fix bug where tibbles would not work with d3_nest2 (c1f70c)

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
