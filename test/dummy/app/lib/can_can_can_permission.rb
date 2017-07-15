class CanCanCanPermission < RbacCore::Permission
  def initialize(name, priority: 0, **options, &block)
    super

    @model = options.fetch(:model)
    @block = block
  end

  def call(context, user)
    if block_attached?
      context.can @action, @model, &@block.curry[user]
    else
      context.can @action, @model
    end
  end

  def block_attached?
    !!@block
  end
end
