# frozen_string_literal: true

class CreateRoleAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :role_assignments do |t|
      t.references :user, foreign_key: true, null: false
      t.references :role, foreign_key: true, null: false
    end
  end
end
