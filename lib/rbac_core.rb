require "rbac_core/engine"

require "options_model"
require "rbac_core/permission"
require "rbac_core/mapper"
require "rbac_core/permission_set"
require "rbac_core/computed_permissions"

require "rbac_core/concerns/models/role"

module RbacCore
  class << self
    def permission_set_class
      @permission_set_class ||= PermissionSet.derive "Global"
    end

    def permission_class
      @permission_class ||= Permission
    end

    def permission_class=(klass)
      unless klass && klass < Permission
        raise ArgumentError, "#{klass} should be sub-class of #{Permission}."
      end

      @permission_class = klass
    end
  end
end
