class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string              :name, :null => false
      t.point               :coordinates, :srid => 4326, :with_z => false, :null => false
      t.boolean             :is_terminal
      t.boolean             :is_accessible
      t.integer             :line_id, :null => false
      t.timestamps
    end
    
    add_index :stations, :line_id
  end
end
