/* this "API" is documented at https://gist.github.com/845751 */

Direction = { // {{{
    NULL      : 0, // no heading info
    NORTH     : 1,
    NORTHEAST : 2,
    EAST      : 3,
    SOUTHEAST : 4,
    SOUTH     : 5,
    SOUTHWEST : 6,
    WEST      : 7,
    NORTHWEST : 8
} // }}}

SideOfVehicle = { // {{{
    Left:  0,
    Right: 1
} // }}}

function oppositeSide(side) { // {{{
    if (typeof side == 'undefined') {
        // things default right, so opposite should default left
        return SideOfVehicle.Left;
    }

    switch (side) {
        case SideOfVehicle.Left:  return SideOfVehicle.Right;
        case SideOfVehicle.Right: return SideOfVehicle.Left;
    }
} // }}}

function Heading(heading) { // {{{
    this.heading   = heading; // may be null
    this.direction = directionFromBearing(this.heading);
} // }}}

Heading.prototype.toString = function() { // {{{
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
} // }}}

function Vehicle(position) { // {{{
    this.position  = position;
    this.longitude = position.coords.longitude;
    this.latitude  = position.coords.latitude;
    this.heading   = new Heading(position.coords.heading);
} // }}}

function initVehicleFromGeoLocation(success, error, unsupported) { // {{{
    if (!navigator.geolocation) {
        unsupported;
        return;
    }

    navigator.geolocation.getCurrentPosition(function(position) {
        success(new Vehicle(position));
    }, error);
} // }}}

Vehicle.prototype.toString = function() { // {{{
    return JSON.stringify(this);
} // }}}

Vehicle.prototype.sideOfVehicle = function(position) { // {{{
    var adjustedDirection;
    var diffLong = this.longitude - position.coords.longitude;
    var diffLat  = this.latitude  - position.coords.latitude;

    var northSouth = diffLong >= 0 ? Direction.NORTH : Direction.SOUTH;
    var eastWest   = diffLat  >= 0 ? Direction.EAST  : Direction.WEST;

    /* this might not make sense... */
    var strongerEastWest = Math.abs(diffLat) >= Math.abs(diffLong) ? true : false;

    switch(this.heading.direction) {
        /* fall back is just a guess */
        case Direction.NULL: return SideOfVehicle.Right;

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
        case Direction.EAST:  return northSouth == Direction.NORTH ? SideOfVehicle.Left : SideOfVehicle.Right;
        case Direction.WEST:  return northSouth == Direction.SOUTH ? SideOfVehicle.Left : SideOfVehicle.Right;
    }
} // }}}

Vehicle.prototype.sideOfEvens = function(callback) { // {{{
    var vehicle = this;

    var feature;
    var addrPos;
    var addrNum;
    var addrSide;

    function parseNum(addr) {
        var word = addr.substring(0, addr.indexOf(' '));
        var nums = word.replace(/[^0-9]/g, '');
        return nums.substring(nums.length - 1, nums.length);
    }

    civicApiBox("bos_addresses", this.position, 0.005, function(data) {
        feature = nearestFeature(vehicle.position, data.features);
        addrNum = parseNum(feature.properties.properties.full_addre);
        addrPos = {
            coords: {
                longitude: feature.geometry.coordinates[0],
                latitude:  feature.geometry.coordinates[1]
            }
        }

        addrSide = vehicle.sideOfVehicle(addrPos);
        
        if (Number(addrNum) % 2 == 0)
            callback(addrSide);
        else
            callback(oppositeSide(addrSide));
    });
} // }}}
