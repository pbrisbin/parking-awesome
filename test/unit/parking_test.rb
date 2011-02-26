require 'test_helper'
require 'fakeweb'

class ParkingTest < Test::Unit::TestCase
  def test_parking_initializer
    p = Parking.new(:lat => LAT, :lon => LON, :heading => HEADING)
    assert_equal LAT, p.lat
    assert_equal LON, p.lon
    assert_equal HEADING, p.heading
  end
  
  def test_parking_as_json
    expected = {"success" => true, 
                "address" => '302 Newbury Street, Boston MA', 
                "left" => {"flag" => 'meter', "message" => 'until 8pm'}, 
                "right" => {"flag" => 'ok'} }
    assert_equal expected, Parking.new(:lat => LAT, :lon => LON, :heading => HEADING).as_json
  end
end