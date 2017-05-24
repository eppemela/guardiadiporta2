class CreateStations < ActiveRecord::Migration[5.1]
  def change
    create_table :stations do |t|
      t.string :name
      t.string :mac_addr
      t.datetime :last_seen
      t.boolean :ignore

      t.timestamps
    end
  end
end
