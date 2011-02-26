/* take a longitute and latitue and make a 'bbox' argument for the json 
 * request which boxes that point
 */
function mkBbox(_long, _lat) {
  // todo: zero-volume box ok?
  var longMin = _long;
  var longMax = _long;
  var latMin  = _lat;
  var latMax  = _lat;

  return longMax + ',' + latMin + ',' + longMin + ',' + latMax;
}

/* make the dataset request to see if the given long/lat is on a snow 
 * route or not; if there are features, call the callback with them as 
 * argument
 */
function isSnowRoute(_long, _lat, _callback) {
  var dataset = 'bos_snow_routes';
  var bbox    = mkBbox(_long, _lat);

  $.ajax({
      url: "http://civicapi.com/" + dataset,
      dataType: 'jsonp',
      data: {
          "bbox": bbox
      },
      success: function(data) {
        if (data.features.length) {
          _callback(data.features);
        }
      }
  });
}
