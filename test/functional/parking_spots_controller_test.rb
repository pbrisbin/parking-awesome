require 'test_helper'

class ParkingSpotsControllerTest < ActionController::TestCase
  LAT = 42.348672
  LON = -71.085019
  HEADING = 90.34 #east
  def test_index_success
    get :index, :lat => LAT, :lon => LON, :heading => HEADING,:format => :json
    assert_response :success

    # Left North:
    # Right South:

    expected = {"success" => true, "address" => '302 Newbury Street, Boston MA', "left" => {"flag" => 'meter', "message" => 'until 8pm'}, "right" => {"flag" => 'ok'}}
    
    assert_equal expected, ActiveSupport::JSON.decode(@response.body)
  end

  
end
