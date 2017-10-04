# frozen_string_literal: true

module RbacCore
  class Permission
    attr_reader :name, :priority

    def initialize(name, priority: 0, **options, &block)
      @name = name
      @priority = priority
    end

    def call(context, *)
      raise NotImplementedError
    end

    def hash
      instance_values.hash
    end

    def ==(other)
      unless other.is_a?(RbacCore::Permission)
        return false
      end

      instance_values == other.instance_values
    end
    alias eql? ==
  end
end
