# frozen_string_literal: true

module RoleCore
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def generate_config
        copy_file "role_core.rb", "config/initializers/role_core.rb"
        copy_file "role_core.en.yml", "config/locales/role_core.en.yml"
      end
    end
  end
end
