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
  
  def test_resolve_direction
    # heading north, and west is a side, west is on the left
    assert_equal :left, Parking.resolve_direction('N', 'W')
    assert_equal :right, Parking.resolve_direction('N', 'E')
    
    assert_equal :right, Parking.resolve_direction('S', 'W')
    assert_equal :left, Parking.resolve_direction('S', 'E')
    
    assert_equal :left, Parking.resolve_direction('E', 'N')
    assert_equal :right, Parking.resolve_direction('W', 'N')
    
    assert_equal :left, Parking.resolve_direction('W', 'S')
    assert_equal :right, Parking.resolve_direction('E', 'S')
    
    assert_equal nil, Parking.resolve_direction('W', 'W')
    assert_equal nil, Parking.resolve_direction('W', 'E')
  end
  
  
  def test_parking_computes_correctly_for_valid_left
    seg = segment('W', false)
  #  assert_equal [15840, :left, seg], Parking.primo_message(seg, 'N')

    seg = segment('E', false)
   # assert_equal [15840, :right, seg], Parking.primo_message(seg, 'N')
  end
  
  def test_parking_parses_correctly_for_invalid_left
    #flunk
  end
  
  def test_parking_computes_correctly_for_valid_left_and_right
    #flunk
  end
  
  def test_parking_computes_correctly_for_multiple_matches
    #flunk
  end
  
  private
  
  def segment(side, meter, distance="3 miles", section = "Alewife - Newbury", limit='4 days')
  { :limit=>limit,
    :meter=>meter,
    :side=>side,
    :distance=>distance,
    :until=>"Thu&nbsp;12:00am",
    :street=>"Huntington Ave",
    :section=>"Mass Ave-Harcourt St"}  
  end
end