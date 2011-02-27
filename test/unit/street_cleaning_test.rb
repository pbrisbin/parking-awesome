require 'test_helper'
require 'fakeweb'

class StreetCleaningTest < Test::Unit::TestCase
  # 302 Newbury Street Address
  LAT = 42.348934
  LON = -71.082401
  
  def setup
    setup_street_cleaning_fakeweb
    setup_geocoder_fakeweb
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
  

end