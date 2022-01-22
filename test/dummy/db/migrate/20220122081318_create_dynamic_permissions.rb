class CreateDynamicPermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :dynamic_permissions do |t|
      t.string :group
      t.string :name
      t.boolean :default

      t.timestamps
    end
  end
end
