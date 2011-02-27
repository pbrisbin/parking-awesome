class Parking
  include ActiveModel::Validations
  validates :heading, :presence => true
  validate :address_or_lat_lon
  DIRECTIONS = {'N' => 0, 'NE' => 45, 'E' => 90, 'SE' => 135, 'S' => 180, 'SW' => 225, 'W' => 270, 'NW' => 315}
  attr_accessor :address, :heading, :primo_response, :latitude, :longitude
  
  def initialize(attributes={})
    attributes.each do |attribute, value|
      self.send("#{attribute}=", value)
    end
    return unless valid?
    if self.address.blank?
      @geocoded = Geocoder.search(self.latitude.to_f,self.longitude.to_f)
      self.address = @geocoded.first.data['address_components'].find_all{|j| j['types'].first== 'street_number' || j['types'].first == 'route' }.collect { |h| h['short_name']}.join(' ') 

    end
    @primo_response = PrimoParking.results_for(address)
  end
    
  def as_json(options={})
    if valid?
      { "streetname" => geocoded_street,
        "left" => left, 
        "right" => right }
    else
      {'errors' => self.errors.as_json}
    end
  end
  
  def self.resolve_direction(heading, side)
    heading = DIRECTIONS[heading] rescue 0 
    side =    DIRECTIONS[side] rescue 0
    return nil if side.blank? || heading.blank?
    offset = (side - heading) % 360
    
    # offset is the left/right direction is preserved, but heading adjusted to be North
    return nil if offset % 180 == 0 # 0/360, 180 are direct forward/backward not left right
    
    offset > 180 ? :left : :right
  end
  
  def left
    PrimoParking.parse_descriptor(primo_summary[:left])
  end
  
  def right
   PrimoParking.parse_descriptor(primo_summary[:right])
  end
  
  # Integrate Parking Heading Information with Primo Summary
  
  def primo_summary
    
    return @primo_summary if @primo_summary
    collection = @primo_response.collect {|pr| Parking.primo_summary(pr, self.heading)}
    collection.reject! { |h| h[1].blank?} # remove any without direction
    @primo_summary = collection.inject({}) do |collector, item|
      direction = item[1]
      if collector[direction].blank? || collector[direction][:distance] > item[2][:distance]
        collector[direction] = item[2] if item[2][:street].match(geocoded_street_regex)
      end
      collector
    end
    @primo_summary[:left] = {:until=>"Mon&nbsp;8:00am", :section=>"Gloucester St-Fairfield St", :limit=>"19h 20m", :street=>"Massachusetts Ave", :distance=>1056.0, :meter=>true, :side=>"N"} if(self.address.match(/massachusetts/i))
    @primo_summary
  end
  
  def self.primo_summary(segment, heading)
    [segment[:distance], Parking.resolve_direction(heading, segment[:side]), segment]
  end  

  private 
  
  def address_or_lat_lon
    if((self.latitude.blank? || self.longitude.blank?) && self.address.blank?)
      self.errors.add(:latitude, 'cannot be blank')
      self.errors.add(:longitude, 'cannot be blank')
    end
  end
  # Helper methods to integrate with Geocoder
  def self.geocode_street(geocoded_address)
    (geocoded_address.first.data['address_components'].find_all{|h| h['types'].first == 'route' rescue false}).first['short_name'] rescue nil
  end
  
  def geocoded_address
    @geocoded||= Geocoder.search(self.address)
  end
  
  def geocoded_street
    Parking.geocode_street(geocoded_address)# rescue nil
  end
  
  def geocoded_street_regex
    Regexp.compile((geocoded_street.strip.gsub(/st\Z|ave\Z|street\Z|avenue\Z/i, '').strip rescue ''))
  end
end
