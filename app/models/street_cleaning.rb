class StreetCleaning
  attr_accessor :side_of_evens, :street_name, :latitude, :longitude, :api_call
  include ActiveModel::Validations
  validates :side_of_evens, :presence => true
  validates :street_name, :presence => true
  validates :latitude, :presence => true
  validates :longitude, :presence => true
  
  def initialize(attributes = {})
    attributes.each do |attribute, value|
      self.send("#{attribute}=".to_sym, value)
    end
    @api_call = BostonStreetScraper::Scraper.new(self.street_name).attributes if valid?
  end
  
  def in_range?(range)
    segments = range.split('-').collect {|h| Geocoder.search("#{h.strip} at #{self.street_name}, Boston, MA") }

      lat_lng = StreetCleaning.geometry_lat_lng(segments.first[0].geometry)
    lat = lat_lng['lat']
    lng = lat_lng['lng']
    
    first_to_last = StreetCleaning.distance_between(lat, lng, segments[1].first)
    
    first_to_last > StreetCleaning.distance_between(self.latitude, self.longitude, segments[0].first) && first_to_last > StreetCleaning.distance_between(self.latitude, self.longitude, segments[1].first)
  end
  
  private
  
  def self.geometry_lat_lng(geometry)
    if geometry.is_a?(Hash)
      geometry['location']
    else
      puts "on the reg"
      geometry['bounds']['northeast']
    end
  end
  def self.distance_between(lat, lng, point)
    lat_lng = geometry_lat_lng(point.geometry)
    lat2 = lat_lng['lat']
    lng2 = lat_lng['lng']
    Geocoder::Calculations.distance_between(lat, lng, lat2, lng2)
  end
end