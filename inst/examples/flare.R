# download.file("https://raw.githubusercontent.com/d3/d3-hierarchy/master/test/data/flare.json",
#               "inst/examples/flare.json")

json <- jsonlite::toJSON(jsonlite::fromJSON(system.file("examples/flare.json",
                                       package = "d3RZoomableTreemap")))
ztm(json)
