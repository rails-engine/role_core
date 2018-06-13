# frozen_string_literal: true

module RoleCore
  class CanCanCanPermission < RoleCore::Permission
    attr_reader :action, :options

    def initialize(name, _namespace: [], _priority: 0, _callable: true, **options, &block)
      super
      return unless _callable

      @model_name = options[:model_name]
      @action = options[:action] || name
      @options = options.except(:model, :model_name, :action)
      @block = block
    end

    def call(context, *args)
      return unless callable

      model = @model_name.constantize
      if block_attached?
        context.can @action, model, &@block.curry[*args]
      else
        context.can @action, model, @options
      end
    end

    def block_attached?
      !!@block
    end
  end
end
