# frozen_string_literal: true

class User < ApplicationRecord
  has_many :projects, dependent: :destroy
  has_many :tasks, dependent: :destroy

  has_many :role_assignments, dependent: :destroy
  has_many :roles, through: :role_assignments

  validates :name, presence: true

  def computed_permissions
    roles.map(&:computed_permissions).reduce(RoleCore::ComputedPermissions.new, &:concat)
  end
end
