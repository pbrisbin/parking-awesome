class Parking
  attr_accessor :lat, :lon, :heading
  
  def initialize(attributes={})
    attributes.each do |attribute, value|
      self.send("#{attribute}=", value)
    end
  end
  
  def as_json(options={})
    { "success" => true, 
      "address" => '302 Newbury Street, Boston MA', 
      "left" => left, 
      "right" => right }
  end
  
  #STUBS
  def address
    "302 Newbury Street, Boston MA"
  end
  
  def left
    {"flag" => 'meter', "message" => 'until 8pm'}
  end
  
  def right
   {"flag" => 'ok'}
  end
end