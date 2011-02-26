class Parking
  DIRECTIONS = {'N' => 0, 'NE' => 45, 'E' => 90, 'SE' => 135, 'S' => 180, 'SW' => 225, 'W' => 270, 'NW' => 315}
  attr_accessor :address, :heading
  
  def initialize(attributes={})
    attributes.each do |attribute, value|
      self.send("#{attribute}=", value)
    end
    @primo_response = PrimoParking.results_for(address)
  end
  
  def as_json(options={})
    { "left" => left, 
      "right" => right }
  end
    
  def self.resolve_direction(heading, side)
    heading = DIRECTIONS[heading]
    side = DIRECTIONS[side]
    
    offset = (side - heading) % 360
    
    # offset is the left/right direction is preserved, but heading adjusted to be North
    return nil if offset % 180 == 0 # 0/360, 180 are direct forward/backward not left right
    
    offset > 180 ? :left : :right
  end
  
  
  #STUBS  
  def left
    {"flag" => 'meter', "message" => 'until 8pm'}
  end
  
  def right
   {"flag" => 'ok'}
  end
end