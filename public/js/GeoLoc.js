/* A better heading representation for our purposes */
Heading.Direction = {
  NULL      : 0 // no heading info
  NORTH     : 1,
  NORTHEAST : 2,
  EAST      : 3,
  SOUTHEAST : 4,
  SOUTH     : 5,
  SOUTHWEST : 6,
  WEST      : 7,
  NORTHWEST : 8
}

function bearingFromPositions(position1, position2) {
  // todo:
}

function directionFromBearing(heading) {
  /* a helper */
  function near(heading, degree) {
    // todo:
  }

  /* null case, feature unsupported */
  if (heading == null) return Heading.Direction.NULL

  /* 0 <= heading < 359 where 0 == True North */
  if (near(heading, 0))  return Heading.Direction.NORTH;
  if (near(heading, 45)) return Heading.Direction.NORTHEAST;
  if (near(heading, 90)) return Heading.Direction.EAST;
  if (near(heading, 135)) return Heading.Direction.SOUTHEAST;
  if (near(heading, 180)) return Heading.Direction.SOUTH;
  if (near(heading, 225)) return Heading.Direction.SOUTHWEST;
  if (near(heading, 270)) return Heading.Direciton.WEST;
  if (near(heading, 315)) return Heading.Direction.NORTHWEST;

  /* impossible, but oh well */
  return Heading.Direciton.NULL;
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
