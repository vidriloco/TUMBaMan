class CreatePaths < ActiveRecord::Migration
  def change
    create_table :paths do |t|
      t.line_string :coordinates_vector, :srid => 4326, :null => false
      t.string :description
      t.integer :line_id, :null => false
      t.timestamps
    end
  end
end
