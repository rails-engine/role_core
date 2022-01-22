# frozen_string_literal: true

class Role < RoleCore::Role
  has_many :role_assignments, dependent: :destroy
  has_many :users, through: :role_assignments

  serialize :permissions, Hash

  def permissions
    DynamicPermission.permission_set_class.new(self[:permissions])
  end
end
