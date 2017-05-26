class AddFemaleBooleanToStations < ActiveRecord::Migration[5.1]
  def change
    add_column :stations, :is_female, :boolean, :default => nil
  end
end
