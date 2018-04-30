# frozen_string_literal: true

module RoleCore
  class Permission
    attr_reader :name, :namespace, :priority, :callable

    def initialize(name, _namespace: [], _priority: 0, _callable: false, **options, &block)
      @name = name
      @namespace = _namespace
      @priority = _priority
      @callable = _callable
    end

    def call(context, *)
      raise NotImplementedError
    end

    def hash
      instance_values.hash
    end

    def ==(other)
      unless other.is_a?(RoleCore::Permission)
        return false
      end

      instance_values == other.instance_values
    end
    alias eql? ==
  end
end
