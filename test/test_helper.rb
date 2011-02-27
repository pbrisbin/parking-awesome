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
  FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?sensor=false&address=Arlington+St%2C+Boston%2C+MA",
    :body => File.open('test/fixtures/arlington.json').read
  FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?sensor=false&address=Charlesgate+East%2C+Boston%2C+MA",
    :body => File.open('test/fixtures/charlesgate.json').read
  FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?sensor=false&address=Commonwealth%2C+Boston%2C+MA",
    :body => File.open('test/fixtures/comm_ave.json').read
  FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?sensor=false&address=Brookline%2C+Boston%2C+MA",
    :body => File.open('test/fixtures/brookeline.json').read
  FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?sensor=false&address=Brookline+Ave%2C+Boston%2C+MA",
    :body => File.open('test/fixtures/brookeline2.json').read
  FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?address=Kenmore+St%2C+Boston%2C+MA&sensor=false",
    :body => File.open('test/fixtures/kenmore.json').read
  FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?address=Arlington+St+at+newbury%2C+Boston%2C+MA&sensor=false",
    :body => File.open('test/fixtures/arlington_at_newbury.json').read
  FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?address=Charlesgate+East+at+newbury%2C+Boston%2C+MA&sensor=false",
    :body => File.open('test/fixtures/charlesgate_at_newbury.json').read
  FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?sensor=false&address=Brookline+Ave+at+newbury%2C+Boston%2C+MA",
    :body => File.open('test/fixtures/brookline_at_newbury.json').read
  FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?sensor=false&address=Kenmore+St+at+newbury%2C+Boston%2C+MA",
    :body => File.open('test/fixtures/kenmore_at_newbury.json').read
    
  FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?sensor=false&address=Commonwealth+at+newbury%2C+Boston%2C+MA",
    :body => File.open('test/fixtures/comm_newbury.json').read
      
  FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?sensor=false&address=Brookline+at+newbury%2C+Boston%2C+MA",
    :body => File.open('test/fixtures/brook_newbury.json').read
    
    
   FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?sensor=false&address=Brookline+Ave+at+newburyodd%2C+Boston%2C+MA",
    :body => File.open('test/fixtures/brookline_fixture.json').read
end

def setup_street_cleaning_fakeweb
  FakeWeb.register_uri :get, "http://www.cityofboston.gov/publicworks/sweeping/?streetname=NEWBURY&Neighborhood=",
    :body => File.open('test/fixtures/newbury.html').read
    
  FakeWeb.register_uri :get, "http://www.cityofboston.gov/publicworks/sweeping/?streetname=NEWBURYODD&Neighborhood=",
    :body => File.open('test/fixtures/newbury_odd.html').read
    
  FakeWeb.register_uri :get, "http://www.cityofboston.gov/publicworks/sweeping/?streetname=NEWBURYEVEN&Neighborhood=",
    :body => File.open('test/fixtures/newbury_even.html').read
    
end

class ActiveSupport::TestCase
  
end
