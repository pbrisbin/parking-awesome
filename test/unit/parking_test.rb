require 'test_helper'
require 'fakeweb'

class ParkingTest < Test::Unit::TestCase
  def setup
    setup_primo_fakeweb
  end
  
  def test_parking_initializer
    p = Parking.new(:address => ADDRESS, :heading => 'N')
    assert_equal ADDRESS, p.address
    assert_equal 'N', p.heading
  end
  
  def test_parking_as_json
    expected = {"streetname" => "Huntington Ave", "left"=>{:flag=>"no", :message=>"bad idea"},
     "right"=>{:flag=>"no", :message=>"bad idea"}}
    assert_equal expected, Parking.new(:address => ADDRESS, :heading => 'N').as_json
  end
  
  def test_initializer_with_no_address
    setup_geocoder_fakeweb
    p = Parking.new(:latitude => '42.348672', :longitude => '-71.085019', :heading => 'N')
    assert_equal "302 Newbury St", p.address
    assert_equal true, p.valid?
  end

  def test_initializer_with_address
    setup_geocoder_fakeweb
    p = Parking.new(:address => '302 Newbury St', :heading => 'N')
    assert_equal "302 Newbury St", p.address
    assert_equal true, p.valid?
  end
  
  def test_invalid_to_json
    p = Parking.new
    expected = {"errors"=>
      {"latitude"=>"cannot be blank",
       "heading"=>"can't be blank",
       "longitude"=>"cannot be blank"}}
    assert_equal expected, ActiveSupport::JSON.decode(p.to_json)
  end
  

  
  def test_initializer_with_no_params
    p = Parking.new
    assert_equal false, p.valid?
    assert_equal "cannot be blank", p.errors[:latitude].first
    assert_equal "cannot be blank", p.errors[:longitude].first 
    assert_equal "can't be blank", p.errors[:heading].first
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
  
  
  def test_primo_summary
    seg = segment('W', false)
    assert_equal [15840, :left, seg], Parking.primo_summary(seg, 'N')

    seg = segment('E', false)
    assert_equal [15840, :right, seg], Parking.primo_summary(seg, 'N')
  end
  
  def test_primo_summarize
    expected = {:left=>
      {:side=>"NW",
       :bad_idea=>true,
       :until=>{},
       :section=>"Mass Ave-Harcourt St",
       :limit=>nil,
       :meter=>false,
       :distance=>700,
       :street=>"Huntington Ave"},
     :right=>
      {:side=>"SE",
       :bad_idea=>true,
       :until=>{},
       :section=>"Mass Ave-Harcourt St",
       :limit=>nil,
       :meter=>false,
       :distance=>900,
       :street=>"Huntington Ave"}}
    assert_equal expected, Parking.new(:address => ADDRESS, :heading => 'N').primo_summary
  end
  
  def test_left_and_right
    p = Parking.new(:address => ADDRESS, :heading => 'N')
    bad_idea = {:flag => 'no', :message => 'bad idea'}
    assert_equal bad_idea, p.left
    assert_equal bad_idea, p.right
  end
      
  private
  
  def segment(side, meter, distance=15840, section = "Alewife - Newbury", limit='4 days')
  { :limit=>limit,
    :meter=>meter,
    :side=>side,
    :distance=>distance,
    :until=>"Thu&nbsp;12:00am",
    :street=>"Huntington Ave",
    :section=>"Mass Ave-Harcourt St"}  
  end
end