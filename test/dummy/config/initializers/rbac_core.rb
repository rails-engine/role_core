RbacCore.permission_class = CanCanCanPermission
RbacCore.permission_set_class.draw do
  group :project, model: Project do
    permission :create, default: true
    permission :destroy
    permission :update
  end

  group :task, model: Task do
    permission :create, default: true
    permission :destroy
    permission :update, priority: 1
    permission :update_my_own, default: true do |user, task|
      task.user_id == user.id
    end
  end
end.finalize!
