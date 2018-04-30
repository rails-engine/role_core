# frozen_string_literal: true

require "role_core/contrib/can_can_can_permission"
RoleCore.permission_class = RoleCore::CanCanCanPermission

RoleCore.permission_set_class.draw do
  group :project, model_name: "Project" do
    permission :create, default: true
    permission :destroy
    permission :update
    permission :read, priority: 1, default: true
    permission :read_public, action: :read, is_public: true

    group :task, model_name: "Task" do
      permission :create, default: true
      permission :destroy, priority: 1
      permission :update, priority: 1
      permission :update_my_own, action: :update, default: true do |user, task|
        task.user_id == user.id
      end
      permission :destroy_my_own, action: :destroy, default: true do |user, task|
        task.user_id == user.id
      end
    end
  end
end.finalize!
