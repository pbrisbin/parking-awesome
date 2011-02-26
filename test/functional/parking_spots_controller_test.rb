require 'test_helper'

class ParkingSpotsControllerTest < ActionController::TestCase
  def setup
    setup_primo_fakeweb
  end
  def test_index_success
    get :index, :address => ADDRESS, :heading => HEADING,:format => :json
    assert_response :success

    # Left North:
    # Right South:

    expected = {"left" => {"flag" => 'meter', "message" => 'until 8pm'}, "right" => {"flag" => 'ok'}}
    
    assert_equal expected, ActiveSupport::JSON.decode(@response.body)
  end

  
end
