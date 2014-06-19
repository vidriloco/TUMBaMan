class CreateVehicles < ActiveRecord::Migration
  def change
    create_table :vehicles do |t|
      t.column            :identifier, :bigint
      t.string            :description
      t.integer           :line_id, :null => false
      t.datetime          :created_at
      t.integer           :public_number
    end
    
    add_index             :vehicles, :identifier, :unique => true
    add_index             :vehicles, :id, :unique => true
  end
end
