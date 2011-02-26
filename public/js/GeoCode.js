var geocoder
var map;

function geocode_init() {
  geocoder = new google.maps.Geocoder();
  var latlng = new google.maps.LatLng(-34.397, 150.644);
  var myOptions = {
    zoom: 20,
    center: latlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
}

/* geocodes an address and returns lat/lng from gmaps */
function getCoords() {
  var address = document.getElementById("address").value;
  geocoder.geocode( { 'address': address }, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      if (results.length == 0) {
        alert("[no results]");
        return;
      }
      alert(results[0].geometry.location); /* success */
    } else {
      alert("[geocoding error]");
    }
  });
}

/* returns short_name from gmaps' geolocation based on a lat/lng */
function getStreetByCoords(clat, clng, callback) {
  /* optional parameters */
  if (!clat && !clng) {
    var input = document.getElementById("latlng").value;
    var latlngStr = input.split(",", 2);
  } else {
    var latlngStr = [ clat, clng ];
  }

  var lat = parseFloat(latlngStr[0]);
  var lng = parseFloat(latlngStr[1]);
  var latlng = new google.maps.LatLng(lat, lng);

  geocoder.geocode( { 'latLng': latlng }, callback);
}

