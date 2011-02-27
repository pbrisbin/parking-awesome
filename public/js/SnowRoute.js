// if the function is undefined, just return, else call it. allows for 
// optional callbacks in other functions
function optional(falure) { if (typeof(failure) == 'undefined') return; else failure; }

/* note: the failure callback is optional */
function isSnowEmergency(vehicle, success, failure) {
    var dataset = 'bos_snow_routes';
    var url     = 'snow_emergency';

    civicApiPoint(dataset, vehicle.position, function(data) {
        // it is a snow route
        if (data.features.length) {
            $.ajax({
                url:      url,
                success:  function(reply) {
                    // it is a snow emergency
                    if (reply.value) {
                        success(data.features);
                    }
                    else {
                        optional(failure);
                    }
                }
            });
        }
        else {
            optional(failure);
        }
    });
}
