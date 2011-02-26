require 'httparty'
require 'uri'
class PrimoParking
  include HTTParty
  def self.scrape(address)
    response = HTTParty.get "http://primospot.com/m/results?address=#{URI.encode(address)}&commit=Search"
    attributes = Nokogiri::HTML(response).css('ol li').collect do |item|
      PrimoParking.parse_link(item.css('a').first.text).merge( {
        :limit => item.css('b').first.text.strip,
        :meter => ! item.css('font').first.blank?,
        :distance => item.css('i').first.text.strip, 
        :until => PrimoParking.parse_until(item.to_s)  })
    end
  end
  
  def self.parse_link(link)
    match = link.match(/(.*?) side (.*?) betw\. \((.*?)\)/)
    {:side => match[1], :street => match[2], :section => match[3]}
  end
  
  def self.parse_until(full_text)
    full_text.match(/\(until\&nbsp;(.*?)\)/)[1]
  end
end