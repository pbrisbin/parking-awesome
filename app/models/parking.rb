class Parking
  attr_accessor :address, :heading
  
  def initialize(attributes={})
    attributes.each do |attribute, value|
      self.send("#{attribute}=", value)
    end
    @primo_response = PrimoParking.results_for(address)
  end
  
  def as_json(options={})
    { "left" => left, 
      "right" => right }
  end
  
  #STUBS  
  def left
    {"flag" => 'meter', "message" => 'until 8pm'}
  end
  
  def right
   {"flag" => 'ok'}
  end
end