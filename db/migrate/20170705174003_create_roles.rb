class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.text :permissions, null: false

      t.string :type, null: false

      t.timestamps
    end
  end
end
