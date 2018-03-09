# frozen_string_literal: true

module RoleCore
  class Mapper
    def initialize(set, **constraints) #:nodoc:
      @constraints = constraints
      @set = set
    end

    def permission(name, default: false, **options, &block)
      @set.register_permission name, default, @constraints.merge(options), &block
      self
    end

    def group(name, **constraints, &block)
      raise ArgumentError, "`name` can't be blank" if name.blank?
      raise ArgumentError, "must provide a block" unless block_given?

      sub_permission_set_class =
        if @set.nested_classes.has_key?(name)
          @set.nested_classes[name]
        else
          klass = PermissionSet.derive "#{name.to_s.classify}"
          @set.embeds_one(name, anonymous_class: klass)

          klass
        end

      sub_permission_set_class.draw(@constraints.merge(constraints), &block)

      self
    end
  end
end
