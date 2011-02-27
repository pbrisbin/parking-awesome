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

SideOfVehicle = {
  Left:  0,
  Right: 1
}

/* usage:
 *
 * var h = new Heading(heading);
 * print(h.toString());
 *
 */
function Heading(heading) {
  this.heading   = heading;
  this.direction = directionFromBearing(this.heading);
}

/* display a heading friendly style */
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

/* usage:
 *
 * var v = new Vehicle(position);
 * print(v.toString());
 *
 */
function Vehicle(position) { // {{{
  this.position  = position;
  this.longitude = position.coords.longitude;
  this.latitude  = position.coords.latitude;
  this.heading   = new Heading(position.coords.heading);
} // }}}

/* use the browser's geolocation info to construct the vehicle object
 * and call the success callback on it
 */
function initVehicleFromGeoLocation(success, error, unsupported) { // {{{
  var v = null;

  if (!navigator.geolocation) {
    unsupported;
    return;
  }

  navigator.geolocation.getCurrentPosition(function(position) {
    v = new Vehicle(position);
    success(v);
  }, error);
} // }}}

Vehicle.prototype.toString = function() { // {{{
  return "vehicle is at (" 
    + this.longitude + ", " 
    + this.latitude + ") heading " 
    + this.heading.toString();
} // }}}

/* given a position, report if it's determined to be on the Left of 
 * Right side of the Vehicle Object
 */
Vehicle.prototype.sideOfVehicle = function(position) { // {{{
  var adjustedDirection = null; 
  var diffLong = this.longitude - position.coords.longitude;
  var diffLat  = this.latitude  - position.coords.latitude;

  var northSouth = diffLong >= 0 ? Direction.NORTH : Direction.SOUTH;
  var eastWest   = diffLat  >= 0 ? Direction.EAST  : Direction.WEST;

  /* this might not make sense... */
  var strongerEastWest = Math.abs(diffLat) >= Math.abs(diffLong) ? true : false;

  switch(this.heading.direction) {
    /* fall back is just a guess */
    case Direction.NULL:  return SideOfVehicle.Right;

    /* leave these as-is */
    case Direction.NORTH:
    case Direction.SOUTH:
    case Direction.EAST:
    case Direction.WEST:
      adjustedDirection = this.heading.direction;

    /* reset from NW to N or W depending on the value of 
     * strongerEastWest */
    case Direction.NORTHEAST: 
      direction = strongerEastWest ? Direction.NORTH : Direction.EAST;
      break;

    case Direction.SOUTHEAST: 
      direction = strongerEastWest ? Direction.SOUTH : Direction.EAST;
      break;

    case Direction.SOUTHWEST: 
      direction = strongerEastWest ? Direction.SOUTH : Direction.WEST;
      break;

    case Direction.NORTHWEST: 
      direction = strongerEastWest ? Direction.NORTH : Direction.WEST;
      break;
  }

  switch(adjustedDirection) {
    case Direction.NORTH: return eastWest   == Direction.WEST  ? SideOfVehicle.Left : SideOfVehicle.Right;
    case Direction.SOUTH: return eastWest   == Direction.EAST  ? SideOfVehicle.Left : SideOfVehicle.Right;
    case Direction.EAST:  return northSouth == Direction.SOUTH ? SideOfVehicle.Left : SideOfVehicle.Right;
    case Direction.WEST:  return northSouth == Direction.SOUTH ? SideOfVehicle.Left : SideOfVehicle.Right;
  }
} // }}}

/* location the address nearest to the vehicle */
Vehicle.prototype.sideOfEvens = function(callback) { // {{{
  var feature;

  civicApiBox("bos_addresses", this.position, 0.01, function(data) {
    feature = nearestFeature(this.position, data.features);
    //callback(feature.properties.properties.full_addre);
    // todo:
    callback(SideOfVehicle.Right);
  });
} // }}}
