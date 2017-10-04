# frozen_string_literal: true

module RbacCore
  class Role < ApplicationRecord
    include RbacCore::Concerns::Models::Role
  end
end
