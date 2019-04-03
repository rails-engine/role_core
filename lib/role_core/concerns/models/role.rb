# frozen_string_literal: true

module RoleCore::Concerns
  module Models
    module Role
      extend ActiveSupport::Concern

      included do
        validates :name,
                  presence: true

        delegate :computed_permissions, to: :permissions

        serialize :permissions, RoleCore.permission_set_class
      end
      
      # one management UI per group 
      def assign_attributes(new_attributes)
        group = new_attributes.delete("group")
        if !new_attributes.respond_to?(:stringify_keys)
          raise ArgumentError, "When assigning attributes, you must pass a hash as an argument."
        end
        return if new_attributes.blank?

        attributes                  = new_attributes.stringify_keys
        multi_parameter_attributes  = []
        nested_parameter_attributes = []

        attributes = sanitize_for_mass_assignment(attributes)
        attributes.each do |k, v|
          if k.include?("(")
            multi_parameter_attributes << [ k, v ]
          elsif v.is_a?(Hash)
            nested_parameter_attributes << [ k, v ]
          else
            _assign_attribute(k, v)
          end
        end
        
        assign_nested_parameter_attributes(nested_parameter_attributes, group) unless nested_parameter_attributes.empty?
        assign_multiparameter_attributes(multi_parameter_attributes) unless multi_parameter_attributes.empty?
      end

      def _assign_attribute(k, v, group="")
        if group.present?
          public_send("#{k}=", {"#{group}": v})
        else
          public_send("#{k}=", v)
        end
      rescue NoMethodError, NameError
        if respond_to?("#{k}=")
          raise
        else
          raise UnknownAttributeError.new(self, k)
        end
      end

      def assign_nested_parameter_attributes(pairs, group="")
        pairs.each { |k, v| _assign_attribute(k, v, group) }
      end

      def permissions_attributes=(value)
        permissions.update_attributes value
      end
    end
  end
end
