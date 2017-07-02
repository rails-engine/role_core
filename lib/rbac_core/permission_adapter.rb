module RbacCore
  class PermissionAdapter
    attr_reader :action, :priority

    def initialize(action, priority: 0, **options, &block)
      @action = action
      @priority = priority
    end

    def call(context, *)
      raise NotImplementedError
    end

    def hash
      instance_values.hash
    end

    def ==(other)
      unless other.is_a?(RbacCore::PermissionAdapter)
        return false
      end

      instance_values == other.instance_values
    end
    alias eql? ==
  end
end
