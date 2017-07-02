RbacCore.permission_adapter_class = CanCanCanPermissionAdapter
RbacCore.permission_set_class.draw do
  group :project, model: Project do
    permission :create, true
    permission :destroy
    permission :update
  end

  group :task, model: Task do
    permission :create, true
    permission :destroy
    permission :update, priority: 1
    permission :update_my_own, true do |user, task|
      task.user_id == user.id
    end
  end
end.finalize!
