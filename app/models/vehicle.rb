class Vehicle < ActiveRecord::Base
  has_many :instants
  belongs_to :line
end
