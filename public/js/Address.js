SideOfVehicle = {
  Left:  0,
  Right: 1
}

/* usage:
 *
 * var v = new Vehicle(position);
 * print(v.toString());
 *
 */
function Vehicle(position) {
  this.longitude = position.coords.longitude;
  this.latitude  = position.coords.latitude;
  this.heading   = new Heading(position.coords.heading);
  this.setOddEvens(position);
}

Vehicle.prototype.toString = function() {
  return "vehicle is at (" 
    + this.longitude + ", " 
    + this.latitude + ") heading " 
    + this.heading.toString() + ". evens are on the " 
    + (this.evens == SideOfVehicle.Left ? "left" : "right");
}

/* usage:
 *
 * var v = new Vehicle(position);
 * var p = someOtherPosition;
 *
 * var side = v.sideOfVehicle(p); // returns SideOfVehicle.Left or .Right
 *
 */
Vehicle.prototype.sideOfVehicle = function(position) {
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
}

/* used when initializing a new Vehicle() */
Vehicle.prototype.setOddEvens = function() {
  /* set odds */
  var odd = findOddAddress(this);

  if (odd) {
    this.odds = this.sideOfVehicle(odd);
  }
  else {
    /* guess is fallback ;O */
    this.odds = SideOfVehicle.Right;
  }

  /* evens are whatever odds are not */
  this.evens = this.odds != SideOfVehicle.Left ? SideOfVehicle.Left : SideOfVehicle.Right;
}

function findOddAddress(vehicle) {
  // todo:
  return null;
}

function getStreetNum(id) {
  civicMeta("bos_addresses", id, function(data) {
    if (data.error) {
      alert(data.error);
    } else {
      alert(data.full_address);
    }
  });
}
