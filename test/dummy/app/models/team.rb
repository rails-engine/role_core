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
        begin
          # You MAY need to cache this if you meet N+1 issue here.
          # Consider caching at app start.
          # Don't forget to refresh the cache when permission definition changed.
          dynamic_permissions = DynamicPermission.all

          RoleCore::PermissionSet.derive("DynamicPermissionSet").draw do
            dynamic_permissions.each do |dp|
              permission dp.key, default: dp.default?
            end
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
