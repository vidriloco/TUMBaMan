class Transport < ActiveRecord::Base
  has_many :lines
  
  validates :name, presence: true
  
  def mode_enum
    ["autobus", "metro", "bicicleta"]
  end
end
