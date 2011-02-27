class StreetCleaning
  attr_accessor :side_of_evens, :street_name
  include ActiveModel::Validations
  validates :side_of_evens, :presence => true
  validates :street_name, :presence => true
  
  def initialize(attributes = {})
    attributes.each do |attribute, value|
      self.send("#{attribute}=".to_sym, value)
    end
    @api_call = BostonStreetScraper::Scraper.new(self.street_name).attributes if valid?
  end
  
end