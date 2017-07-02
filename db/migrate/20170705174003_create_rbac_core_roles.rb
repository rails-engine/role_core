class CreateRbacCoreRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :rbac_core_roles do |t|
      t.string :name, null: false
      t.text :permissions, null: false, default: ""

      t.string :type, null: false

      t.timestamps
    end
  end
end
