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

      def permissions_attributes=(value)
        self[:permissions].update_attributes value
      end
    end
  end
end
