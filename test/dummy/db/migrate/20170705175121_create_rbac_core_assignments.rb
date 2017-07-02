class CreateRbacCoreAssignments < ActiveRecord::Migration[5.1]
  def change
    create_table :assignments do |t|
      t.references :subjectable, polymorphic: true, null: false, index: {name: "index_assignments_on_subjectable"}
      t.references :role, foreign_key: {to_table: :rbac_core_roles}, null: false, index: true

      t.timestamps
    end
  end
end
