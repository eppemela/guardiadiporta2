class AddOriginalNameToStations < ActiveRecord::Migration[5.1]
  def change
    add_column :stations, :original_name, :string, :default => nil
  end
end
