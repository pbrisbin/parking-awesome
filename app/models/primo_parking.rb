require 'httparty'
require 'uri'
class PrimoParking
  include HTTParty
  
  def self.normalize_distance(distance_string)
    feet = distance_string.match(/(.*?) feet/)
    return feet[1].to_i if feet
    
    miles = distance_string.match(/(.*?) mile/)
    return miles[1].to_f * 5280 if miles
    
    nil
  end
  
  def self.results_for(address)
    pages = PrimoParking.pages_for(address)
    results = []
    pages.each do |url, response|
      results = results | PrimoParking.scrape(response)
    end
    results
  end
  def self.pages_for(address)
    url = "http://primospot.com/m/results?address=#{URI.encode(address)}&commit=Search"
    first = HTTParty.get url
    
    pagination = Nokogiri::HTML(first).css('.pagination a').inject({}) do |collector, item|
      item_url = "http://primospot.com#{item.first[1].to_s}"
      collector.merge!({item_url => HTTParty.get(item_url)})
    end
    pagination.merge({url => first})
  end
  
  def self.scrape(response)     
    attributes = Nokogiri::HTML(response).css('ol li').collect do |item|
      bad_idea = item.to_s.match(/bad idea/) ? {:bad_idea => true} : {}
      PrimoParking.parse_link(item.css('a').first.text).merge(bad_idea).merge( {
        :limit => (item.css('b').first.text.strip rescue nil),
        :meter => item.css('font').first.nil? ? false : item.css('font').first.text.strip == '*' ,
        :distance => PrimoParking.normalize_distance(item.css('i').first.text.strip), 
        :until => PrimoParking.parse_until(item.to_s)  })
    end
  end
  
  def self.parse_descriptor(attributes)
    ok = {:flag => 'ok', :message => 'you can has'}
    return ok if attributes.blank?
    return {:flag => 'meter', :message => "until #{attributes[:until]}"} if attributes[:meter]
    return {:flag => 'no', :message => 'bad idea'} if attributes[:bad_idea]
    ok
  end
  
  def self.parse_link(link)
    match = link.match(/(.*?) side (.*?) betw\. \((.*?)\)/)
    {:side => match[1], :street => match[2], :section => match[3]} rescue {}
  end
  
  def self.parse_until(full_text)
    full_text.match(/\(until\&nbsp;(.*?)\)/)[1] rescue {}
  end
end