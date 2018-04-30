# frozen_string_literal: true

# YOU NEED TO RESTART APP AFTER CHANGING THIS FILE !!!

require "role_core/contrib/can_can_can_permission"
RoleCore.permission_class = RoleCore::CanCanCanPermission

RoleCore.permission_set_class.draw do
  permission :foo, _callable: false
  permission :bar, _callable: false

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
      permission :update_my_own, action: :update, default: true do |user, task|
        task.user_id == user.id
      end
      permission :destroy_my_own, action: :destroy, default: true do |user, task|
        task.user_id == user.id
      end
    end
  end

  group :task, _callable: false do
    permission :read
    permission :create, default: true
    permission :destroy
    permission :update
  end
end.finalize!
