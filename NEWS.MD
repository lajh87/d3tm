# dtm 0.3.1
## New Release (January 7th, 2019)
### Major Changes
* Removed column names from data in `d3_nest2` and added a variable to pass to
the htmlWidget which places the vector into an array that is indexed based on depth
[(a94f49)](https://gitlab.com/lajh87/d3tm/commit/a94f4929770d4b5aa209a68ca339a7b6faaf0293)
* Added parent _and_ child click and hover events for Shiny
[(0cd2cd)](https://gitlab.com/lajh87/d3tm/commit/0cd2cdc9cfffcb67c03ebeed6c45d2a0b6f99b98)
* Removed key field from `d3_nest2` and added Shiny bindings for for click and 
hover events
[(99b0c2)](https://gitlab.com/lajh87/d3tm/commit/99b0c23075c3f1c4e11bd0ef68441f9ac4792a21)
* Update the tooltip so that it switches sides when it gets halfway across the 
element [(c5eeb2)](https://gitlab.com/lajh87/d3tm/commit/c5eeb20fbdf5b234314fa9f8c8ef2742bb6a6207)


# d3tm 0.3
## New Release (January 6th, 2019)
### Major Changes 
* Rename from d3RZoomableTreemap to d3tm 
[(d480b3)](https://gitlab.com/lajh87/d3tm/commit/d480b3f42f029ea9c58fa83b1ab2a43054ee8a5d)

### Bug Fixes
* Fixed issue when rendering in a div that had style position equal to relative
[(89cca7)](https://gitlab.com/lajh87/d3tm/commit/89cca7ae3ac7a35ea0010493f95c2e8a18464ae2)
* Fixed issue where resizing the treemap window would revert back to starting level
[(b7d57b)](https://gitlab.com/lajh87/d3tm/commit/b7d57b6e08035747ea48834ee5646010e2bcd47a)

# d3RZoomableTreemap 0.2.1
## Bug Fixes
* Fixed shiny hover inputs
* Fixed tooltip bounding so it does not overflow container

# d3RZoomableTreemap 0.2
## Major Changes
* Added d3_nest2 to convert data to a hierarchy that d3 expects
* Added tooltip to treemap that consider col_name

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
