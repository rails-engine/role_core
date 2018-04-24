# frozen_string_literal: true

module RoleCore
  module Generators
    class ModelGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      def generate_model
        copy_file "role.rb", "app/models/role.rb"
      end
    end
  end
end
