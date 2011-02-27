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
  
  def summarize
    ct = cleaning_times
    ret_val = {}
    
    if(ct[:left])
      ret_val[:left] = {:flag => 'noparking', :message => ct[:left].join(' ')}  if StreetCleaning.does_day_apply(StreetCleaning.day(ct[:left].first), StreetCleaning.weeks(ct[:left][1])) rescue nil
    end
    if(ct[:right])
      ret_val[:right] = {:flag => 'noparking', :message => ct[:right].join(' ')}   if StreetCleaning.does_day_apply(StreetCleaning.day(ct[:left].first), StreetCleaning.weeks(ct[:left][1])) rescue nil
    end
    ret_val
  end
  
  def cleaning_times
    result = {}
    @api_call.each do |section|
      if in_range? section[:section]
        if ! section[:side].strip.match(/odd|even/i)
          return {:left => section[:schedule], :right => section[:schedule]}
        elsif section[:side].match(/even/i)
          side = self.side_of_evens.match(/left/i) ? :left : :right
          result[side] = section[:schedule] if result[side].blank? 
        else
          side = self.side_of_evens.match(/left/i) ? :right : :left
          result[side] = section[:schedule] if result[side].blank?        
        end
      end
    end
    result
  end
  
  def self.week_of_month
    # TODO: this is not the correct value instead of estimating
    (Time.now.day / 7).to_i + 1
  end
  
  def self.day(full_string)
    day = full_string.split(' ').last
    return nil if day.blank? || day.match(/every/i)
    day
  end
  
  def self.does_day_apply(day, month_dates=nil)
    return true if day.blank?
    return false if (Date::DAYNAMES[Time.now.wday] rescue '').match(Regexp.compile(day, 'i')).blank? 
    
    return ! month_dates.index(week_of_month.to_s).blank? && month_dates != []
  end
  
  def self.weeks(full_string)
    split = full_string.split(' ')
    return nil if split.count < 2
    ccount = split.count.to_s.to_i
    split[0, ccount -1]
  end
  
  def summary
    
  end
  private
  
  def self.geometry_lat_lng(geometry)
    geometry['location']
  end
  
  def self.distance_between(lat, lng, point)
    lat_lng = geometry_lat_lng(point.geometry)
    lat2 = lat_lng['lat']
    lng2 = lat_lng['lng']
    Geocoder::Calculations.distance_between(lat, lng, lat2, lng2)
  end
end