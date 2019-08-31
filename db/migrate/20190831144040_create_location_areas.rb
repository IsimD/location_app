class CreateLocationAreas < ActiveRecord::Migration[6.0]
  def change
    create_table :location_areas do |t|
      t.string :name

      t.timestamps
    end
  end
end
