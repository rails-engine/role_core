require "rbac_core/engine"

require "options_model"
require "rbac_core/permission_adapter"
require "rbac_core/mapper"
require "rbac_core/permission_set"

require "rbac_core/concerns/models/role"

module RbacCore
  class << self
    def permission_set_class
      @permission_set_class ||= PermissionSet.derive "Global"
    end

    def permission_adapter_class
      @permission_adapter_class ||= PermissionAdapter
    end

    def permission_adapter_class=(klass)
      unless klass && klass < PermissionAdapter
        raise ArgumentError, "#{klass} should be sub-class of #{PermissionAdapter}."
      end

      @permission_adapter_class = klass
    end
  end
end
