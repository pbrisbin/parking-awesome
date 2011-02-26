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

function Heading(heading) {
  this.heading   = heading;
  this.direction = directionFromBearing(this.heading);
}

Heading.prototype.toString = function() {
  switch(this.direction) {
    case Direction.NULL     : return "null";
    case Direction.NORTH    : return "N";
    case Direction.NORTHEAST: return "NE";
    case Direction.EAST     : return "E";
    case Direction.SOUTHEAST: return "SE";
    case Direction.SOUTH    : return "S";
    case Direction.SOUTHWEST: return "SW";
    case Direction.WEST     : return "W";
    case Direction.NORTHWEST: return "NW";
  }
}

/* thanks http://www.movable-type.co.uk/scripts/latlong.html for the 
 * maths.
 *
 * takes two positions and returns a new Heading object
 */
function toRad(deg) {
  var pi = Math.PI;
  return deg * (180/pi);
}

function toDeg(rad) {
  var pi = Math.PI;
  return rad * (pi/180);
}

function getDistance(position1, position2) {
  var precision = 4;
  var R = 6371; // earth's radius

  var lat1 = toRad(position1.coords.latitude);
  var lon1 = toRad(position1.coords.longitude);
  var lat2 = toRad(position2.coords.latitude);
  var lon2 = toRad(position2.coords.longitude);

  var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
          Math.cos(lat1) * Math.cos(lat2) * 
          Math.sin(dLon/2) * Math.sin(dLon/2);

  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  var d = R * c;

  return d.toPrecisionFixed(precision);
}

function closestPosition(position, positions) {
  var p, d;
  var min = null;
  var closest;

  for (i in positions) {
    p = positions[i];
    d = getDistance(position, p);

    if (!min || d < min) {
      min     = d;
      closest = p;
    }
  }

  return closest;
}

function headingFromPositions(position1, position2) {
  var lat1 = toRad(position1.coords.latitude);
  var lat2 = toRad(position2.coords.latitude);
  var dLon = toRad(position2.coords.longitude - position1.coords.longitude);

  var y = Math.sin(dLon) * Math.cos(lat2);
  var x = Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1) * Math.cos(lat2) * Math.cos(dLon);
  var brng =  Math.atan2(y,x);

  return new Heading((toDeg(brng) + 360) % 360);
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
