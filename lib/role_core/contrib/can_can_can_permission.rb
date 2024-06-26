# frozen_string_literal: true

module RoleCore
  class CanCanCanPermission < RoleCore::Permission
    attr_reader :action, :options

    def initialize(name, _namespace: [], _priority: 0, _callable: true, **options, &block)
      super
      return unless _callable

      @model_name = options[:model_name]
      @subject = options[:subject]
      @action = options[:action] || name
      @with_identity = options[:with]
      @options = options.except(:model, :model_name, :subject, :action, :with, :_namespace, :_priority, :_callable)
      @block = block
    end

    def call(context, user, *args)
      return unless callable

      subject = @subject || @model_name.constantize
      if block_attached?
        context.can @action, subject, &@block.curry[*args]
      elsif @with_identity
        context.can @action, subject, @options.merge(@with_identity => user)
      else
        context.can @action, subject, @options
      end
    rescue NameError
      raise "You must provide a valid model name."
    end

    def block_attached?
      !!@block
    end
  end
end
