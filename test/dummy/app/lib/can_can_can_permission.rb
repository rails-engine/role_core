# frozen_string_literal: true

class CanCanCanPermission < RoleCore::Permission
  attr_reader :action, :options

  def initialize(name, priority: 0, **options, &block)
    super

    @model = options.fetch(:model)
    @action = options.fetch(:action) { name }
    @options = options.except(:model, :action)
    @block = block
  end

  def call(context, *args)
    if block_attached?
      context.can @action, @model, &@block.curry[*args]
    else
      context.can @action, @model, @options
    end
  end

  def block_attached?
    !!@block
  end
end
