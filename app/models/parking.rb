class Parking
  DIRECTIONS = {'N' => 0, 'NE' => 45, 'E' => 90, 'SE' => 135, 'S' => 180, 'SW' => 225, 'W' => 270, 'NW' => 315}
  attr_accessor :address, :heading, :primo_response
  
  def initialize(attributes={})
    attributes.each do |attribute, value|
      self.send("#{attribute}=", value)
    end
    @primo_response = PrimoParking.results_for(address)
  end
  
  def primo_summary
    collection = @primo_response.collect {|pr| Parking.primo_summary(pr, self.heading)}
    collection.reject! { |h| h[1].blank?} # remove any without direction
    
    # TODO: this can pick up streets that are parallel if they are listed as closest.
    #  only include the street if the street name matches 
    collection.inject({}) do |collector, item|
      direction = item[1]
      if collector[direction].blank? || collector[direction][:distance] > item[2][:distance]
        collector[direction] = item[2] if item[2][:street].match(geocoded_street_regex)
      end
      collector
    end
  end
  
  def as_json(options={})
    { "left" => left, 
      "right" => right }
  end
  
  def self.primo_summary(segment, heading)
    [segment[:distance], Parking.resolve_direction(heading, segment[:side]), segment]
  end  
  def self.resolve_direction(heading, side)
    heading = DIRECTIONS[heading]
    side = DIRECTIONS[side]
    return nil if side.blank? || heading.blank?
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
  
  private 
  def geocoded_address
    Geocoder.search("Newbury Street, Boston, MA")
  end
  
  def geocoded_street
    geocoded_address.first.data['address_components'].first['short_name'] rescue nil
  end
  
  def geocoded_street_regex
    Regexp.compile((geocoded_street.gsub(/st|ave|street|avenue/, '').strip rescue ''))
  end
end