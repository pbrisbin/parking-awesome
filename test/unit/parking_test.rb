require 'test_helper'
require 'fakeweb'

class ParkingTest < Test::Unit::TestCase
  def setup
    setup_primo_fakeweb
  end
  
  def test_parking_initializer
    p = Parking.new(:address => ADDRESS, :heading => HEADING)
    assert_equal ADDRESS, p.address
    assert_equal HEADING, p.heading
  end
  
  def test_parking_as_json
    expected = {"left" => {"flag" => 'meter', "message" => 'until 8pm'}, 
                "right" => {"flag" => 'ok'} }
    assert_equal expected, Parking.new(:address => ADDRESS, :heading => HEADING).as_json
  end
end