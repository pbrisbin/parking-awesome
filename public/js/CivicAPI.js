/* generic wrappers for using the civic api */

var url  = "http://civicapi.com/";

function civicAPI(dataset, lng, lat, callback) {
  var bbox = lng + ',' + lat + ',' + lng + ',' + lat; // todo: zero-volume box

  $.ajax({
      url:      url + dataset,
      dataType: 'jsonp',
      data:     { "bbox": bbox },
      success:  callback
  });
}

function civicMeta(dataset, id, callback) {
    $.ajax({
        url:      url + dataset + "/" + id,
        dataType: "jsonp",
        success:  callback
    });
}
