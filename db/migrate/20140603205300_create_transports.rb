class CreateTransports < ActiveRecord::Migration
  def change
    create_table :transports do |t|
      t.string :name, :null => false 
      t.string :mode, :null => false
      t.timestamps
    end    
  end
end
