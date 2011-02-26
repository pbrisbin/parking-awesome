/* look for snow route features at the given point; if features, call 
 * success(features), else call failure.
 */
function isSnowRoute(lng, lat, success, failure) {
  civicAPI('bos_snow_routes', lng, lat, function(data) {
    if (data.features.length) {
      success(data.features);
    }
    else {
      failure;
    }
  });
}
