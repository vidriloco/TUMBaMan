class Line < ActiveRecord::Base
  has_many :stations
  has_many :vehicles
  has_many :paths
  
  belongs_to :transport
  
  validates :name, :right_terminal, :left_terminal, :transport_id, :color, presence: true
end
