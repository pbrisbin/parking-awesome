ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
FakeWeb.allow_net_connect = false
ADDRESS ="Huntington Ave, Boston"
HEADING = 90.34 #east
def setup_primo_fakeweb
  FakeWeb.register_uri :get, "http://primospot.com/m/results?address=Huntington%20Ave,%20Boston&commit=Search",
    :body => File.open('test/fixtures/primo_huntington.html').read
  FakeWeb.register_uri :get, "http://primospot.com/m/results?address=Huntington+Ave%2C+Boston&commit=Search&page=2",
    :body => File.open('test/fixtures/primo_huntington_page2.html').read
  FakeWeb.register_uri :get, "http://primospot.com/m/results?address=Huntington+Ave%2C+Boston&commit=Search&page=3",
    :body => File.open('test/fixtures/primo_huntington_page3.html').read
end

class ActiveSupport::TestCase
end
