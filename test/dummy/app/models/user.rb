# frozen_string_literal: true

class User < ApplicationRecord
  has_many :projects, dependent: :destroy
  has_many :tasks, dependent: :destroy

  has_many :role_assignments
  has_many :roles, through: :role_assignments

  validates :name, presence: true

  def permitted_permissions
    roles.map(&:permitted_permissions).reduce(RbacCore::ComputedPermissions.new, &:concat)
  end
end
