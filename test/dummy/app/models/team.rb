# frozen_string_literal: true

class Team < ApplicationRecord
  validates :name,
            presence: true,
            uniqueness: true

  before_save :write_permissions
  before_validation :validate_permissions

  def permissions
    @permissions ||= permission_set_class.load self[:permissions]
  end

  def permissions_attributes=(value)
    permissions.replace value
  end

  delegate :computed_permissions, to: :permissions

  private

    def permission_set_class
      @permission_set_class ||=
        RoleCore::PermissionSet.derive("DynamicPermissionSet").draw do
          DynamicPermission.all.each do |dp|
            permission dp.key, default: dp.default?
          end
        end
    end

    def write_permissions
      self[:permissions] = permission_set_class.dump(permissions)
    end

    def validate_permissions
      unless permissions.valid?
        errors.add :permissions, :invalid
      end
    end
end
