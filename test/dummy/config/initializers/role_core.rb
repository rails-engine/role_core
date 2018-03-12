# frozen_string_literal: true

RoleCore.permission_class = CanCanCanPermission
RoleCore.permission_set_class.draw do
  group :project, model: Project do
    permission :create, default: true
    permission :destroy
    permission :update
    permission :read, priority: 1, default: true
    permission :read_public, action: :read, is_public: true
  end

  group :task, model: Task do
    permission :create, default: true
    permission :destroy
    permission :update, priority: 1
    permission :update_my_own, action: :update, default: true do |user, task|
      task.user_id == user.id
    end
  end
end.finalize!
