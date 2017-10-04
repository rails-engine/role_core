# frozen_string_literal: true

module RbacCore
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
