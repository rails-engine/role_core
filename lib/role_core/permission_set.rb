# frozen_string_literal: true

module RoleCore
  class PermissionSet < OptionsModel::Base
    def permitted_permission_names
      attributes.select { |_, v| v }.keys
    end

    def computed_permissions(include_nesting: true)
      permissions = self.class.registered_permissions.slice(*permitted_permission_names).values
      permissions.concat nested_attributes.values.map(&:computed_permissions).flatten! if include_nesting && nested_attributes.any?

      ComputedPermissions.new(permissions)
    end

    class << self
      def i18n_scope
        :role_core
      end

      def use_relative_model_naming?
        true
      end

      def permission_class
        @permission_class || RoleCore.permission_class
      end

      def permission_class=(klass)
        raise ArgumentError, "#{klass} should be sub-class of #{Permission}." unless klass && klass < Permission

        @permission_class = klass
      end

      def draw(constraints = {}, &block)
        raise ArgumentError, "must provide a block" unless block_given?

        Mapper.new(self, constraints).instance_exec(&block)

        self
      end

      def registered_permissions
        @registered_permissions ||= ActiveSupport::HashWithIndifferentAccess.new
      end

      def register_permission(name, default = false, options = {}, &block)
        raise ArgumentError, "`name` can't be blank" if name.blank?

        attribute name, :boolean, default: default
        registered_permissions[name] = permission_class.new name, **options, &block
      end

      PERMITTED_ATTRIBUTE_CLASSES = [Symbol].freeze
      def permitted_attribute_classes
        PERMITTED_ATTRIBUTE_CLASSES
      end
    end
  end
end
