require 'test_helper'
require 'fakeweb'

class PrimoParkingTest < Test::Unit::TestCase
  def setup
    setup_primo_fakeweb
  end
  
  def test_all_pages_for
    pages = ["http://primospot.com/m/results?address=Huntington%20Ave,%20Boston&commit=Search",
      "http://primospot.com/m/results?address=Huntington+Ave%2C+Boston&commit=Search&page=2",
      "http://primospot.com/m/results?address=Huntington+Ave%2C+Boston&commit=Search&page=3"]
    
    expected = pages.inject({}) do |collector, item|
      collector.merge!({item => HTTParty.get(item)})
    end
    assert_equal expected, PrimoParking.pages_for('Huntington Ave, Boston')
  end
  
  def test_parse_link
    expected = {:side => 'W', :street => 'Exeter St', :section => 'Boylston St-Huntington Ave'}
    assert_equal expected, PrimoParking.parse_link("W side Exeter St betw. (Boylston St-Huntington Ave)")
  end

  def test_parse_until
    assert_equal '1:05pm', PrimoParking.parse_until("stufff (until&nbsp;1:05pm) daha")    
  end
  
  def test_normalize_distance
    assert_equal 900, PrimoParking.normalize_distance("900 feet")
    assert_equal 1056, PrimoParking.normalize_distance("0.2 miles")
    assert_equal nil, PrimoParking.normalize_distance('ajkshasjkhd')
  end
  
  def test_parse_primo_into_descriptor_ok
    expected = {:flag => 'freeparking', :message => 'you can haz'}
    assert_equal expected, PrimoParking.parse_descriptor({:until=>"Thu&nbsp;12:00am",
      :section=>"Mass Ave-Harcourt St",
      :meter=>false,
      :street=>"Huntington Ave",
      :limit=>"4 days",
      :distance=>1056.0,
      :side=>"SE"})
  end
  
  def test_parse_primo_into_descriptor_meter
    expected = {:flag => 'meter', :message => 'until Thu&nbsp;12:00am'}
    assert_equal expected, PrimoParking.parse_descriptor({:until=>"Thu&nbsp;12:00am",
      :section=>"Mass Ave-Harcourt St",
      :meter=>true,
      :street=>"Huntington Ave",
      :limit=>"4 days",
      :distance=>1056.0,
      :side=>"SE"})    
  end
  
  def test_parse_primo_into_descriptor_bad_idea
    expected = {:flag => 'noparking', :message => 'bad idea'}
    assert_equal expected, PrimoParking.parse_descriptor({:until=>"Thu&nbsp;12:00am",
      :section=>"Mass Ave-Harcourt St",
      :bad_idea => true,
      :meter=>false,
      :street=>"Huntington Ave",
      :limit=>"4 days",
      :distance=>1056.0,
      :side=>"SE"})
  end
  
  def test_parse_primo_into_descriptor_nil
    expected = {:flag => 'freeparking', :message => 'you can haz'}
    assert_equal expected, PrimoParking.parse_descriptor(nil)
  end
  
  def test_scrape
    
    expected = {:until=>"Thu&nbsp;12:00am",
      :section=>"Mass Ave-Harcourt St",
      :meter=>false,
      :street=>"Huntington Ave",
      :limit=>"4 days",
      :distance=>1056.0,
      :side=>"SE"},
     {:until=>"Sun&nbsp;2:00am",
      :section=>"Ring Rd-Exeter St",
      :meter=>false,
      :street=>"Boylston St",
      :limit=>"14h 55m",
      :distance=>900,
      :side=>"SE"},
     {:until=>"1:05pm",
      :section=>"Newbury St-Boylston St",
      :meter=>true,
      :street=>"Fairfield St",
      :limit=>"2 hours",
      :distance=>1056.0,
      :side=>"E"},
     {:until=>"1:05pm",
      :section=>"Ring Rd-Exeter St",
      :meter=>true,
      :street=>"Boylston St",
      :limit=>"2 hours",
      :distance=>1056.0,
      :side=>"NW"},
     {:until=>"1:05pm",
      :section=>"Newbury St-Boylston St",
      :meter=>true,
      :street=>"Exeter St",
      :limit=>"2 hours",
      :distance=>1584.0,
      :side=>"W"},
     {:until=>"1:05pm",
      :section=>"Gloucester St-Fairfield St",
      :meter=>true,
      :street=>"Boylston St",
      :limit=>"2 hours",
      :distance=>1584.0,
      :side=>"N"},
     {:until=>"1:05pm",
      :section=>"Exeter St-Dartmouth St",
      :meter=>true,
      :street=>"Huntington Ave",
      :limit=>"2 hours",
      :distance=>1584.0,
      :side=>"N"},
     {:until=>"1:05pm",
      :section=>"Garrison St-Harcourt St",
      :meter=>true,
      :street=>"St Botolph St",
      :limit=>"2 hours",
      :distance=>1584.0,
      :side=>"NW"},
     {:until=>"1:05pm",
      :section=>"Newbury St-Boylston St",
      :meter=>true,
      :street=>"Fairfield St",
      :limit=>"2 hours",
      :distance=>1056.0,
      :side=>"W"},
     {:until=>"1:05pm",
      :section=>"Boylston St-Huntington Ave",
      :meter=>true,
      :street=>"Exeter St",
      :limit=>"2 hours",
      :distance=>800,
      :side=>"W"}
        
      assert_equal expected, PrimoParking.scrape(HTTParty.get("http://primospot.com/m/results?address=Huntington%20Ave,%20Boston&commit=Search"))
      
  end
  
  def test_results_for
    expected = [{:until=>"Thu&nbsp;12:00am",
      :section=>"Mass Ave-Harcourt St",
      :meter=>false,
      :street=>"Huntington Ave",
      :limit=>"4 days",
      :distance=>1056.0,
      :side=>"SE"},
     {:until=>"Sun&nbsp;2:00am",
      :section=>"Ring Rd-Exeter St",
      :meter=>false,
      :street=>"Boylston St",
      :limit=>"14h 55m",
      :distance=>900,
      :side=>"SE"},
     {:until=>"1:05pm",
      :section=>"Newbury St-Boylston St",
      :meter=>true,
      :street=>"Fairfield St",
      :limit=>"2 hours",
      :distance=>1056.0,
      :side=>"E"},
     {:until=>"1:05pm",
      :section=>"Ring Rd-Exeter St",
      :meter=>true,
      :street=>"Boylston St",
      :limit=>"2 hours",
      :distance=>1056.0,
      :side=>"NW"},
     {:until=>"1:05pm",
      :section=>"Newbury St-Boylston St",
      :meter=>true,
      :street=>"Exeter St",
      :limit=>"2 hours",
      :distance=>1584.0,
      :side=>"W"},
     {:until=>"1:05pm",
      :section=>"Gloucester St-Fairfield St",
      :meter=>true,
      :street=>"Boylston St",
      :limit=>"2 hours",
      :distance=>1584.0,
      :side=>"N"},
     {:until=>"1:05pm",
      :section=>"Exeter St-Dartmouth St",
      :meter=>true,
      :street=>"Huntington Ave",
      :limit=>"2 hours",
      :distance=>1584.0,
      :side=>"N"},
     {:until=>"1:05pm",
      :section=>"Garrison St-Harcourt St",
      :meter=>true,
      :street=>"St Botolph St",
      :limit=>"2 hours",
      :distance=>1584.0,
      :side=>"NW"},
     {:until=>"1:05pm",
      :section=>"Newbury St-Boylston St",
      :meter=>true,
      :street=>"Fairfield St",
      :limit=>"2 hours",
      :distance=>1056.0,
      :side=>"W"},
     {:until=>"1:05pm",
      :section=>"Boylston St-Huntington Ave",
      :meter=>true,
      :street=>"Exeter St",
      :limit=>"2 hours",
      :distance=>800,
      :side=>"W"},
     {:until=>{},
      :section=>"Fairfield St-Ring Rd",
      :meter=>false,
      :street=>"Boylston St",
      :limit=>nil,
      :distance=>1056.0,
      :side=>"NW"},
     {:until=>{},
      :section=>"Mass Ave-Harcourt St",
      :meter=>false,
      :street=>"Huntington Ave",
      :limit=>nil,
      :distance=>900,
      :side=>"SE",
      :bad_idea=>true},
     {:until=>{},
      :section=>"Gloucester St-Fairfield St",
      :meter=>false,
      :street=>"Boylston St",
      :limit=>nil,
      :distance=>1056.0,
      :side=>"S",
      :bad_idea=>true},
     {:until=>{},
      :section=>"Fairfield St-Ring Rd",
      :meter=>false,
      :street=>"Boylston St",
      :limit=>nil,
      :distance=>1056.0,
      :side=>"NW",
      :bad_idea=>true},
     {:until=>{},
      :section=>"Follen St-Garrison St",
      :meter=>false,
      :street=>"St Botolph St",
      :limit=>nil,
      :distance=>1584.0,
      :side=>"copy of SE",
      :bad_idea=>true},
     {:until=>{},
      :section=>"Boylston St-Huntington Ave",
      :meter=>false,
      :street=>"Ring Rd",
      :limit=>nil,
      :distance=>100,
      :side=>"W",
      :bad_idea=>true},
     {:until=>{},
      :section=>"Harcourt St-Garrison St",
      :meter=>false,
      :street=>"Huntington Ave",
      :limit=>nil,
      :distance=>1056.0,
      :side=>"SE",
      :bad_idea=>true},
     {:until=>{},
      :section=>"Mass Ave-Harcourt St",
      :meter=>false,
      :street=>"Huntington Ave",
      :limit=>nil,
      :distance=>700,
      :side=>"NW",
      :bad_idea=>true},
     {:until=>{},
      :section=>"Fairfield St-Ring Rd",
      :meter=>false,
      :street=>"Boylston St",
      :limit=>nil,
      :distance=>800,
      :side=>"SE",
      :bad_idea=>true},
     {:until=>{},
      :section=>"Boylston St-Huntington Ave",
      :meter=>false,
      :street=>"Ring Rd",
      :limit=>nil,
      :distance=>300,
      :side=>"E",
      :bad_idea=>true},
     {:until=>{},
      :section=>"Garrison St-W Newton St",
      :meter=>false,
      :street=>"Huntington Ave",
      :limit=>nil,
      :distance=>1584.0,
      :side=>"NW",
      :bad_idea=>true},
     {:until=>{},
      :section=>"Harcourt St-Garrison St",
      :meter=>false,
      :street=>"Huntington Ave",
      :limit=>nil,
      :distance=>700,
      :side=>"NW",
      :bad_idea=>true}]
    
    assert_equal expected, PrimoParking.results_for('Huntington Ave, Boston')
    
  end
  def test_bad_idea
    response = HTTParty.get("http://primospot.com/m/results?address=Huntington+Ave%2C+Boston&commit=Search&page=2")
    results = PrimoParking.scrape(response)
    assert results.first[:bad_idea].blank?
    assert ! results[1][:bad_idea].blank?
  end
end