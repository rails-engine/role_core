module RbacCore::Concerns
  module Models
    module Role
      extend ActiveSupport::Concern

      included do
        validates :name,
                  presence: true

        delegate :permitted_permissions, to: :permissions

        after_initialize do
          self.permissions ||= ::RbacCore.permission_set_class
        end

        serialize :permissions, RbacCore.permission_set_class
      end

      def permissions_attributes=(value)
        permissions.update_attributes value
      end
    end
  end
end
