var geocoder
var map;

var g_streetname;
var g_latlng;

function initialize() {
  geocoder = new google.maps.Geocoder();
  var latlng = new google.maps.LatLng(-34.397, 150.644);
  var myOptions = {
    zoom: 20,
    center: latlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
}

function getLatLng() {
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
  });
}

function reverseGeocode() {
  var input = document.getElementById("latlng").value;
  var latlngStr = input.split(",", 2);
  var lat = parseFloat(latlngStr[0]);
  var lng = parseFloat(latlngStr[1]);
  var latlng = new google.maps.LatLng(lat, lng);


  geocoder.geocode( { 'latLng': latlng }, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      var a = results[0].address_components;
      for (i = 0; i < a.length; i++) {
        for (j = 0; j < a[i].types.length; j++) {
          if (a[i].types[j] == "route") {
            alert(a[i].short_name); /* success */
            return;
          }
        }
      }
      alert("[no results]");
    } else {
      alert("[geocoding error]");
    }
  });
}

