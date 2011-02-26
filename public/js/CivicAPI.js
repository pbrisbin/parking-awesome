/* generic wrapper for using the civic api
 *
 * arguments:
 *
 *   data set name
 *   longitude
 *   latitude
 *   callback(data)
 *
 */
function civicAPI(dataset, lng, lat, callback) {
  var url  = "http://civicapi.com/";
  var bbox = lng + ',' + lat + ',' + lng + ',' + lat; // todo: zero-volume box

  $.ajax({
      url:      url + dataset,
      dataType: 'jsonp',
      data:     { "bbox": bbox },
      success:  callback
  });
}
