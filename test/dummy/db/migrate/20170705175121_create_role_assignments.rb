# frozen_string_literal: true

class CreateRoleAssignments < ActiveRecord::Migration[5.1]
  def change
    create_table :role_assignments do |t|
      t.references :user, null: false, index: true
      t.references :role, null: false, index: true

      t.timestamps
    end
  end
end
