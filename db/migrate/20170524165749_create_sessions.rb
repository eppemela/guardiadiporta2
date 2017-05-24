class CreateSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions do |t|
      t.datetime :start
      t.datetime :end
      t.integer :duration
      t.boolean :open
      t.belongs_to :station, foreign_key: true

      t.timestamps
    end
  end
end
