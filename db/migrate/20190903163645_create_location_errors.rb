class CreateLocationErrors < ActiveRecord::Migration[6.0]
  def change
    create_table :location_errors do |t|
      t.string  :message
      t.integer :location_id

      t.timestamps
    end
  end
end
