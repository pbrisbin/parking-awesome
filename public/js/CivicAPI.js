/* generic wrappers for using the civic api */

var url  = "http://civicapi.com/";

function fixPrecision(n, p) {
    /* ugh */
    return Number(Number(n).toFixed(p));
}

/* boxsize is in decimal degress, for now */
function civicApiBox(dataset, position, boxsize, callback) {
    var p = 5;
    var lon = fixPrecision(position.coords.longitude, p);
    var lat = fixPrecision(position.coords.latitude, p);

    boxsize = fixPrecision(boxsize, p);

    var lonMax = fixPrecision(lon + (boxsize / 2), p);
    var lonMin = fixPrecision(lon - (boxsize / 2), p);
    var latMax = fixPrecision(lat + (boxsize / 2), p);
    var latMin = fixPrecision(lat - (boxsize / 2), p);

    var bbox = lonMin + ',' + latMin + ',' + lonMax + ',' + latMax;

    $.ajax({
        url:      url + dataset,
        dataType: 'jsonp',
        data:     { "bbox": bbox },
        success:  callback
    });
}

/* special case, zero-volume box */
function civicApiPoint(dataset, position, callback) {
    civicApiBox(dataset, position, 0.00, callback);
}

/* in a list of features, find the nearest to your source position */
function nearestFeature(position, features) {
    var f, p, d, closest;
    var min = null;

    for (i in features) {
        f = features[i];
        p = {
            coords: {
                longitude: f.geometry.coordinates[0],
                latitude:  f.geometry.coordinates[1]
            }
        }

        d = getDistance(position, p);

        if (!min || d < min) {
            min     = d;
            closest = f;
        }
    }

    return closest;
}
