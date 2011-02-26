/* A better heading representation for our purposes */
Direction = {
  NULL      : 0, // no heading info
  NORTH     : 1,
  NORTHEAST : 2,
  EAST      : 3,
  SOUTHEAST : 4,
  SOUTH     : 5,
  SOUTHWEST : 6,
  WEST      : 7,
  NORTHWEST : 8
}

/* http://www.movable-type.co.uk/scripts/latlong.html */
function bearingFromPositions(position1, position2) {
  var lat1 = position1.coord.latitude.toRad();
  var lat2 = position2.coord.latitude.toRad();
  var dLon = (position2.coord.longitude - position1.coord.longitude).toRad();

  var y = Math.sin(dLon) * Math.cos(lat2);
  var x = Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1) * Math.cos(lat2) * Math.cos(dLon);
  var brng =  Math.atan2(y,x);

  return (brng.toDeg() + 360) % 360;
}

function directionFromBearing(heading) {
  /* a helper */
  function near(heading, degree) {
    var delta = 45 / 2;

    if (degree == 0) // special case
      return (heading <= degree + delta || heading > 360 - delta)

    return (heading <= degree + delta && heading > degree - delta)
  }

  /* null case, feature unsupported */
  if (heading == null) return Direction.NULL

  /* 0 <= heading < 359 where 0 == True North */
  if (near(heading, 0))  return Direction.NORTH;
  if (near(heading, 45)) return Direction.NORTHEAST;
  if (near(heading, 90)) return Direction.EAST;
  if (near(heading, 135)) return Direction.SOUTHEAST;
  if (near(heading, 180)) return Direction.SOUTH;
  if (near(heading, 225)) return Direction.SOUTHWEST;
  if (near(heading, 270)) return Direciton.WEST;
  if (near(heading, 315)) return Direction.NORTHWEST;

  /* impossible, but oh well */
  return Direciton.NULL;
}

/* get location data. call success(position) on OK, error on error, and 
 * unsupported on the special unsupported error case.
 */
function getLocation(success, error, unsupported) {
  if (!navigator.geolocation) {
    unsupported;
    return;
  }

  navigator.geolocation.getCurrentPosition(success, error);
}
