ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
FakeWeb.allow_net_connect = false
ADDRESS ="Huntington Ave, Boston"
def setup_primo_fakeweb
  FakeWeb.register_uri :get, "http://primospot.com/m/results?address=Huntington%20Ave,%20Boston&commit=Search",
    :body => File.open('test/fixtures/primo_huntington.html').read
  FakeWeb.register_uri :get, "http://primospot.com/m/results?address=Huntington+Ave%2C+Boston&commit=Search&page=2",
    :body => File.open('test/fixtures/primo_huntington_page2.html').read
  FakeWeb.register_uri :get, "http://primospot.com/m/results?address=Huntington+Ave%2C+Boston&commit=Search&page=3",
    :body => File.open('test/fixtures/primo_huntington_page3.html').read
  FakeWeb.register_uri :get, "http://primospot.com/m/results?address=Huntington%20Ave&commit=Search",
    :body => File.open('test/fixtures/primo_huntington.html').read
  FakeWeb.register_uri :get, "http://primospot.com/m/results?address=302%20Newbury%20St&commit=Search",
      :body => File.open('test/fixtures/primo_huntington.html').read
end

def setup_geocoder_fakeweb
  FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?latlng=42.348672%2C-71.085019&sensor=false",
    :body => File.open('test/fixtures/302_newbury.json').read
  FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?sensor=false&address=Huntington+Ave%2C+Boston",
    :body => File.open('test/fixtures/huntington_ave_boston.json').read
  FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?latlng=42.3478%2C-71.080637&sensor=false",
      :body => File.open('test/fixtures/huntington_ave_boston.json').read
end

class ActiveSupport::TestCase
  
end
