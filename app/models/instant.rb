class Instant < ActiveRecord::Base
  belongs_to :vehicle
  
  attr_accessor :lat, :lon
  before_validation :update_coordinates
  
  validates :lat, :lon, :vehicle_id, presence: true
  
  rails_admin do         
    edit do
      include_all_fields
      exclude_fields :created_at, :updated_at
            
      field :lat
      field :lon
    end
  end
  
  def lat
    return @lat unless @lat.nil?
    coordinates.y unless coordinates.nil?
  end
  
  def lon
    return @lon unless @lon.nil?
    coordinates.x unless coordinates.nil?
  end
  
  protected
  def update_coordinates
    self.coordinates = "POINT(#{self.lon.to_f} #{self.lat.to_f})"
  end
end
