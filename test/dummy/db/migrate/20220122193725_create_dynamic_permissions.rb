# frozen_string_literal: true

class CreateDynamicPermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :dynamic_permissions do |t|
      t.string :name, null: false
      t.string :key, null: false, index: { unique: true }
      t.boolean :default, null: false, default: false

      t.timestamps
    end
  end
end
