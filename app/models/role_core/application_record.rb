# frozen_string_literal: true

module RoleCore
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
