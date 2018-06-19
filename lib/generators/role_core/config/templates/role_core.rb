# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# For I18n, see `config/locales/role_core.en.yml` for details which followed the rule of ActiveRecord's I18n,
# See <http://guides.rubyonrails.org/i18n.html#translations-for-active-record-models>.

# Uncomment below if you want to integrate with CanCanCan
#
#   require "role_core/contrib/can_can_can_permission"
#   RoleCore.permission_class = RoleCore::CanCanCanPermission

RoleCore.permission_set_class.draw do
  # Define permissions for the application. For example:
  #
  #   permission :foo, default: true # `default: true` means grant to user by default
  #   permission :bar
  #
  # You can also group permissions by using `group`:
  #
  #   group :project do
  #     permission :create
  #     permission :destroy
  #     permission :update
  #     permission :read
  #     permission :read_public
  #
  #     # `group` supports nesting
  #     group :task do
  #       permission :create
  #       permission :destroy
  #       permission :update
  #       permission :read
  #     end
  #   end
  #
  # For CanCanCan integration, you can pass `model_name` for `group` or `permission`. For example:
  #
  #   group :project, model_name: "Project" do
  #     permission :create
  #     permission :destroy, model_name: 'Plan'
  #   end
  #
  # That will translate to CanCanCan's abilities (if user has these permissions),
  # the permission's name will be the action:
  #
  #   can :create, Project
  #   can :destroy, Plan
  #
  # You can pass `_priority` argument to `permission`
  #
  #   group :project, model_name: "Project" do
  #     permission :read_public,
  #     permission :read, _priority: 1
  #   end
  #
  # That will made 'read' prior than `read_public`.
  #
  # For CanCanCan's hash of conditions
  # (see https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities#hash-of-conditions)
  # you can simply pass them as arguments for `permission` even with a block
  #
  #   group :task, model_name: "Task" do
  #     permission :read_public, is_public: true
  #     permission :update_my_own, action: :update, default: true do |user, task|
  #       task.user_id == user.id
  #     end
  #   end
  #
  # Although permission's name will be CanCanCan's action by default,
  # you can pass `action` argument to override it.
  #
  #   permission :read_public, action: :read, is_public: true
  #
  # For some reason, you won't interpret the permission to CanCanCan,
  # you can set `_callable: false` to `permission` or `group`
  #
  #   permission :read, _callable: false
  #
end.finalize! # Call `finalize!` to freezing the definition, that's optional.
