##
#  This class implements a coordinate vector object with additional attributes such as color, description.
#  Additionally, it references a line object
#
#  For creating such an object the user has to provide the coordinates field with a coordinate vector on a KML compatible representation preceded by an R
class Path < ActiveRecord::Base
  belongs_to :line
  before_validation :transform_coordinates
  
  validates :line_id, :description, :coordinates_vector, presence: true
  attr_accessor :coordinates
  
  rails_admin do         
    edit do
      include_all_fields
      exclude_fields :created_at, :updated_at
            
      field :coordinates, :text 
    end
  end
  
  def coordinates
    return @coordinates if coordinates_vector.nil?
    coordinates_vector.to_s
  end
  
  protected
  def transform_coordinates
    if @coordinates[0] == "R"
      parsed_coordinates = @coordinates.gsub(',0','|').gsub(',',' ').gsub('|', ' , ').chop.chop.chop.gsub("R ", '')
      self.coordinates_vector = "LINESTRING (#{parsed_coordinates})"
    end
  end
  
end
