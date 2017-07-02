class Assignment < ApplicationRecord
  belongs_to :subjectable, polymorphic: true
  belongs_to :role, inverse_of: :assignments

  validates :role,
            uniqueness: {scope: :subjectable}
end
