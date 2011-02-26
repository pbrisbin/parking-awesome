require 'test_helper'
require 'fakeweb'

class PrimoParkingTest < Test::Unit::TestCase
  def test_parse_link
    expected = {:side => 'W', :street => 'Exeter St', :section => 'Boylston St-Huntington Ave'}
    assert_equal expected, PrimoParking.parse_link("W side Exeter St betw. (Boylston St-Huntington Ave)")
  end

  def test_parse_until
    assert_equal '1:05pm', PrimoParking.parse_until("stufff (until&nbsp;1:05pm) daha")    
  end
  
  def test_scrape
    FakeWeb.register_uri :get, "http://primospot.com/m/results?address=Huntington%20Ave,%20Boston&commit=Search",
      :body => File.open('test/fixtures/primo_huntington.html').read
    
    expected = { :limit=>"4 days",
        :meter=>false,
        :side=>"SE",
        :distance=>"0.2 miles",
        :until=>"Thu&nbsp;12:00am",
        :street=>"Huntington Ave",
        :section=>"Mass Ave-Harcourt St"},
       {:limit=>"14h 55m",
        :meter=>false,
        :side=>"SE",
        :distance=>"900 feet",
        :until=>"Sun&nbsp;2:00am",
        :street=>"Boylston St",
        :section=>"Ring Rd-Exeter St"},
       {:limit=>"2 hours",
        :meter=>true,
        :side=>"E",
        :distance=>"0.2 miles",
        :until=>"1:05pm",
        :street=>"Fairfield St",
        :section=>"Newbury St-Boylston St"},
       {:limit=>"2 hours",
        :meter=>true,
        :side=>"NW",
        :distance=>"0.2 miles",
        :until=>"1:05pm",
        :street=>"Boylston St",
        :section=>"Ring Rd-Exeter St"},
       {:limit=>"2 hours",
        :meter=>true,
        :side=>"W",
        :distance=>"0.3 miles",
        :until=>"1:05pm",
        :street=>"Exeter St",
        :section=>"Newbury St-Boylston St"},
       {:limit=>"2 hours",
        :meter=>true,
        :side=>"N",
        :distance=>"0.3 miles",
        :until=>"1:05pm",
        :street=>"Boylston St",
        :section=>"Gloucester St-Fairfield St"},
       {:limit=>"2 hours",
        :meter=>true,
        :side=>"N",
        :distance=>"0.3 miles",
        :until=>"1:05pm",
        :street=>"Huntington Ave",
        :section=>"Exeter St-Dartmouth St"},
       {:limit=>"2 hours",
        :meter=>true,
        :side=>"NW",
        :distance=>"0.3 miles",
        :until=>"1:05pm",
        :street=>"St Botolph St",
        :section=>"Garrison St-Harcourt St"},
       {:limit=>"2 hours",
        :meter=>true,
        :side=>"W",
        :distance=>"0.2 miles",
        :until=>"1:05pm",
        :street=>"Fairfield St",
        :section=>"Newbury St-Boylston St"},
       {:limit=>"2 hours",
        :meter=>true,
        :side=>"W",
        :distance=>"800 feet",
        :until=>"1:05pm",
        :street=>"Exeter St",
        :section=>"Boylston St-Huntington Ave"}
        
      assert_equal expected, PrimoParking.scrape('Huntington Ave, Boston')
  end
end