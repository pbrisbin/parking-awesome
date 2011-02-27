require 'test_helper'
require 'fakeweb'

class StreetCleaningTest < Test::Unit::TestCase

  def test_initialize
    sc = StreetCleaning.new(:side_of_evens => 'left', :street_name => 'newbury')
    assert_equal true, sc.valid?
  end
  
  def test_initialize_invalid_constructor
    sc = StreetCleaning.new
    assert_equal false, sc.valid?
    assert_equal "can't be blank", sc.errors[:side_of_evens].first
    assert_equal "can't be blank", sc.errors[:street_name].first
  end

end