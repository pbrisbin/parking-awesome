/* look for snow route features at the given position; if features, call 
 * success(features), else call failure (optional).
 */
function isSnowRoute(vehicle, success, failure) {

  civicApiPoint('bos_snow_routes', vehicle.position, function(data) {
    if (data.features.length) {
      success(data.features);
    }
    else {
      // just return if user doesn't pass a fail callback
      if (typeof(failure) == 'undefined') return;

      failure;
    }
  });
}
