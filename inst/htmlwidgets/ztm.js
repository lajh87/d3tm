HTMLWidgets.widget({

  name: "ztm",

  type: "output",

  factory: function(el, width, height) {

    var instance = { }, node;

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

  if( HTMLWidgets.shinyMode )
  {
    Shiny.addCustomMessageHandler('resetInputValue',
                function(variableName){
                  Shiny.onInputChange(variableName, null);
                  });

     Shiny.addCustomMessageHandler('shinySelect',
                function(selector){
                  node = d3.select("#node-flare\\.vis");
                  });


  }

    return {

      renderValue: function(x) {
        data = x.data,
        instance = draw(el, x.data, node);
      },

      resize: function(width, height) {

       draw(el, data, node)

      },

      instance: instance

    };

  }
});
