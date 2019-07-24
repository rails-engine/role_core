# frozen_string_literal: true

module RoleCore
  class Permission
    attr_reader :name, :namespace, :priority, :callable

    def initialize(name, _namespace: [], _priority: 0, _callable: false, **_options, &_block)
      @name = name
      @namespace = _namespace
      @priority = _priority
      @callable = _callable
    end

    def call(_context, *)
      raise NotImplementedError
    end

    delegate :hash, to: :instance_values

    def ==(other)
      return false unless other.is_a?(RoleCore::Permission)

      instance_values == other.instance_values
    end
    alias eql? ==
  end
end
