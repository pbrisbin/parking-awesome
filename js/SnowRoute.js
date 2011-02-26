/* take a longitute and latitue and make a 'bbox' argument for the json 
 * request which boxes that point. todo: define a range or make a 
 * zero-volume box?
 */
function mkBbox(_long, _lat) {
  // todo:
}

/* make the dataset request to see if the given long/lat is on a snow 
 * route or not; returns true/false
 */
function isSnowRoute(_long, _lat) {
  var dataset = 'boston_snow_route';
  var bbox    = mkBbox(_long, _lat);

  $.ajax({
      url: "http://civicapi.com/" + dataset,
      dataType: 'jsonp',
      data: {
          "bbox": bbox
      },
      success: function(o) {
        features = o.features;
        if (o.features.length()) {
          return true;
        }
      }
  });

  return false;
}
