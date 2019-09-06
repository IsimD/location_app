class Remove < ActiveRecord::Migration[6.0]
  def change
    drop_table :location_areas
  end
end
