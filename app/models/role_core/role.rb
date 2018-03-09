# frozen_string_literal: true

module RoleCore
  class Role < ApplicationRecord
    include RoleCore::Concerns::Models::Role

    self.table_name = "roles"
  end
end
