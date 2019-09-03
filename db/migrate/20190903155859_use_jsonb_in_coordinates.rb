class UseJsonbInCoordinates < ActiveRecord::Migration[6.0]
  def change
    remove_column :locations, :coordinates
    add_column :locations, :coordinates, :float, array: true, default: []
  end
end
