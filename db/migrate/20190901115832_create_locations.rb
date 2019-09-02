class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.string :name, null: false
      t.text :coordinates
      t.integer :user_id

      t.timestamps
    end
  end
end
