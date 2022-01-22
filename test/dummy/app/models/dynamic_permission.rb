# frozen_string_literal: true

class DynamicPermission < ApplicationRecord
  validates :name,
            presence: true,
            uniqueness: true

  validates :key,
            presence: true,
            uniqueness: true
end
