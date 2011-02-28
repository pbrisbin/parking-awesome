require 'test_helper'
require 'fakeweb'

class StreetCleaningTest < Test::Unit::TestCase
  # 302 Newbury Street Address
  LAT = 42.348934
  LON = -71.082401
  
  def setup
    setup_street_cleaning_fakeweb
    setup_geocoder_fakeweb
    
    FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?sensor=false&address=Brookline+Ave+at+newburyodd%2C+Boston%2C+MA",
     :body => File.open('test/fixtures/brookline_fixture.json').read
     FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?sensor=false&address=Brookline+Ave+at+newburyeven%2C+Boston%2C+MA",
      :body => File.open('test/fixtures/brookline_fixture.json').read 
      
      FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?sensor=false&address=Kenmore+St+at+newburyodd%2C+Boston%2C+MA",
        :body => File.open('test/fixtures/kenmore_at_newbury.json').read
        FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?sensor=false&address=Kenmore+St+at+newburyeven%2C+Boston%2C+MA",
          :body => File.open('test/fixtures/kenmore_at_newbury.json').read

          FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?sensor=false&address=Arlington+St+at+newburyodd%2C+Boston%2C+MA",
            :body => File.open('test/fixtures/arlington_at_newbury.json').read

            FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?sensor=false&address=Kenmore+St+at+newburyeven%2C+Boston%2C+MA",
              :body => File.open('test/fixtures/arlington_at_newbury.json').read
    
              FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?sensor=false&address=Charlesgate+East+at+newburyodd%2C+Boston%2C+MA",
                :body => File.open('test/fixtures/charlesgate_at_newbury.json').read
    
                FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?sensor=false&address=Charlesgate+East+at+newburyeven%2C+Boston%2C+MA",
                  :body => File.open('test/fixtures/charlesgate_at_newbury.json').read
    

                  FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?sensor=false&address=Arlington+St+at+newburyodd%2C+Boston%2C+MA",
                    :body => File.open('test/fixtures/arlington_at_newbury.json').read

                    FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?sensor=false&address=Arlington+St+at+newburyeven%2C+Boston%2C+MA",
                      :body => File.open('test/fixtures/arlington_at_newbury.json').read
    


                      FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?sensor=false&address=Commonwealth+at+newburyeven%2C+Boston%2C+MA",
                        :body => File.open('test/fixtures/comm_newbury.json').read

                        FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?sensor=false&address=Commonwealth+at+newburyodd%2C+Boston%2C+MA",
                          :body => File.open('test/fixtures/comm_newbury.json').read

    
                          FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?sensor=false&address=Brookline+at+newburyodd%2C+Boston%2C+MA",
                            :body => File.open('test/fixtures/brook_newbury.json').read
    
                            FakeWeb.register_uri :get, "http://maps.google.com/maps/api/geocode/json?sensor=false&address=Brookline+at+newburyeven%2C+Boston%2C+MA",
                              :body => File.open('test/fixtures/brook_newbury.json').read
    
    
    
    
    
  end
  
  def test_initialize
    sc = StreetCleaning.new(:side_of_evens => 'left', :street_name => 'newbury', :latitude => LAT, :longitude => LON)
    assert_equal true, sc.valid?
    assert_equal [{:street=>"Newbury St ", :district=>"Roxbury ", :side=>" ", :section=>"Brookline Ave - Kenmore St", :schedule=>["Everyday", "12:01am - 7am"]}, {:street=>"Newbury St ", :district=>"Roxbury ", :side=>" ", :section=>"Arlington St - Charlesgate East", :schedule=>["Everyday", "12:01am - 7am"]}, {:street=>"Newbury St ", :district=>"Roxbury ", :side=>"Even ", :section=>"Commonwealth - Brookline", :schedule=>["2nd 4th Wed", "12pm - 4pm", "Apr 13"]}, {:street=>"Newbury St ", :district=>"Roxbury ", :side=>"Odd ", :section=>"Commonwealth - Brookline", :schedule=>["1st 3rd Wed", "12pm - 4pm", "Apr 6"]}], sc.api_call
  end
  
  def test_initialize_invalid_constructor
    sc = StreetCleaning.new
    assert_equal false, sc.valid?
    assert_equal "can't be blank", sc.errors[:side_of_evens].first
    assert_equal "can't be blank", sc.errors[:street_name].first
    assert_equal "can't be blank", sc.errors[:latitude].first
    assert_equal "can't be blank", sc.errors[:longitude].first
  end
  
  def test_in_range
    sc = StreetCleaning.new(:side_of_evens => 'left', :street_name => 'newbury', :latitude => LAT, :longitude => LON)
    
    assert_equal true, sc.in_range?("Arlington St - Charlesgate East")
#    assert_equal false, sc.in_range?("Commonwealth - Brookline")
    assert_equal false, sc.in_range?("Brookline Ave - Kenmore St")
    
  end
  
  def test_active_street_cleanings_both_sides
    sc = StreetCleaning.new(:side_of_evens => 'left', :street_name => 'newbury', :latitude => LAT, :longitude => LON)
    
    expected= { :left => ["Everyday", "12:01am - 7am"],
                :right => ["Everyday", "12:01am - 7am"]}
    
    assert_equal expected, sc.cleaning_times
  end


  
  def test_active_street_cleanings_odd_left
    sc = StreetCleaning.new(:side_of_evens => 'left', :street_name => 'newburyodd', :latitude => LAT, :longitude => LON)
    # Applies to odd side of street
    # Evens are on left
    # right
    expected= { :right => ["Everyday", "12:01am - 7am"]}
    assert_equal expected, sc.cleaning_times
  end

  def test_active_street_cleanings_odd_right
    sc = StreetCleaning.new(:side_of_evens => 'right', :street_name => 'newburyodd', :latitude => LAT, :longitude => LON)
    # Applies to odd side of street
    # Evens are on right
    # right
    expected= { :left => ["Everyday", "12:01am - 7am"]}
    assert_equal expected, sc.cleaning_times
  end
  
  def test_active_street_cleanings_even_left
    sc = StreetCleaning.new(:side_of_evens => 'left', :street_name => 'newburyeven', :latitude => LAT, :longitude => LON)
    # Applies to even side of street
    # Evens are on left
    # left
    expected= { :left => ["Everyday", "12:01am - 7am"]}
    assert_equal expected, sc.cleaning_times
  end
  
  def test_active_strret_cleaning_even_right
    sc = StreetCleaning.new(:side_of_evens => 'right', :street_name => 'newburyeven', :latitude => LAT, :longitude => LON)
    # Applies to even side of street
    # Evens are on right
    # right
    expected= { :right => ["Everyday", "12:01am - 7am"]}
    assert_equal expected, sc.cleaning_times
  end

  

end