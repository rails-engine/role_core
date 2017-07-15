class CreateRoleAssignments < ActiveRecord::Migration[5.1]
  def change
    create_table :role_assignments do |t|
      t.references :subjectable, polymorphic: true, null: false, index: {name: "index_role_assignments_on_subjectable"}
      t.references :role, foreign_key: {to_table: :rbac_core_roles}, null: false, index: true

      t.timestamps
    end
  end
end
