require 'test_helper'

class ParkingSpotsControllerTest < ActionController::TestCase
  def setup
    setup_primo_fakeweb
    setup_geocoder_fakeweb
  end
  def test_index_success
    get :index, :address => ADDRESS, :heading => 'N',:format => :json
    assert_response :success

    expected = {"left"=>{'flag'=>"no", 'message'=>"bad idea"},
     "right"=>{'flag'=>"no", 'message'=>"bad idea"}, "streetname"=>"Huntington Ave"}
    
    assert_equal expected, ActiveSupport::JSON.decode(@response.body)
  end
end
