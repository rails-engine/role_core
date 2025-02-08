# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2022_01_22_193822) do
  create_table "dynamic_permissions", force: :cascade do |t|
    t.string "name", null: false
    t.string "key", null: false
    t.boolean "default", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_dynamic_permissions_on_key", unique: true
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.boolean "is_public", default: true, null: false
    t.integer "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["is_public"], name: "index_projects_on_is_public"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "role_assignments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "role_id", null: false
    t.index ["role_id"], name: "index_role_assignments_on_role_id"
    t.index ["user_id"], name: "index_role_assignments_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.text "permissions"
    t.string "type", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.integer "user_id"
    t.integer "project_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["project_id"], name: "index_tasks_on_project_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.text "permissions", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  add_foreign_key "projects", "users"
  add_foreign_key "role_assignments", "roles"
  add_foreign_key "role_assignments", "users"
  add_foreign_key "tasks", "projects"
  add_foreign_key "tasks", "users"
end
