class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string  :auth_token,    null: false
      t.boolean :default_user,  default: false

      t.timestamps
    end
    add_index :users, :auth_token, unique: true
  end
end
