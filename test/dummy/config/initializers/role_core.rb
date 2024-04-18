# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# For I18n, see `config/locales/role_core.en.yml` for details which followed the rule of ActiveRecord's I18n,
# See <http://guides.rubyonrails.org/i18n.html#translations-for-active-record-models>.

require "role_core/contrib/can_can_can_permission"
RoleCore.permission_class = RoleCore::CanCanCanPermission

RoleCore.permission_set_class.draw do
  group :project, model_name: "Project" do
    permission :create, default: true
    permission :destroy
    permission :update
    permission :read, _priority: 1, default: true
    permission :read_public, action: :read, is_public: true

    group :task, model_name: "Task" do
      permission :create, default: true
      permission :destroy, _priority: 1
      permission :update, _priority: 1
      # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/fetching_records.md
      permission :update_my_own, action: :update, default: true, with: :user
      permission :destroy_my_own, action: :destroy, default: true, with: :user
    end
  end

  permission :super, action: :manage, subject: :all # this equal to `can :manage, :all`

  # These (under the comment) are not in use, just for demo

  group :task, _callable: false do
    permission :read
    permission :create, default: true
    permission :destroy
    permission :update
  end
end.finalize!
