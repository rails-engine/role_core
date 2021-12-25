# frozen_string_literal: true

module RoleCore
  class Mapper
    def initialize(set, constraints = {}) # :nodoc:
      @constraints = constraints
      @constraints[:_namespace] ||= []
      @set = set
    end

    def permission(name, default: false, **options, &block)
      @set.register_permission name, default, @constraints.merge(options), &block
      self
    end

    def group(name, constraints = {}, &block)
      raise ArgumentError, "`name` can't be blank" if name.blank?
      raise ArgumentError, "must provide a block" unless block_given?

      constraints[:_namespace] ||= @constraints[:_namespace].dup
      constraints[:_namespace] << name

      sub_permission_set_class =
        if @set.nested_classes.key?(name)
          @set.nested_classes[name]
        else
          klass_name = constraints[:_namespace].map { |n| n.to_s.classify }.join("::")
          klass = PermissionSet.derive klass_name
          @set.embeds_one(name, anonymous_class: klass)

          klass
        end

      sub_permission_set_class.draw(@constraints.merge(constraints), &block)

      self
    end
  end
end
