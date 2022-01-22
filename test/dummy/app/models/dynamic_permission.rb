class DynamicPermission < ApplicationRecord
  after_commit :redraw_permissions

  def self.permission_set_class
    RoleCore::PermissionSet.derive "Dynamic"
  end

  def self.draw_permissions
    dynamic_permissions = DynamicPermission.all
    RoleCore::PermissionSet.derive("Dynamic").draw do
      dynamic_permissions.each do |dp|
        group(dp.group) do
          permission dp.name
        end
      end
    end
  end

  def redraw_permissions
    self.class.draw_permissions
  end
end
