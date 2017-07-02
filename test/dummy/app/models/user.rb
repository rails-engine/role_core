class User < ApplicationRecord
  has_many :projects, dependent: :destroy
  has_many :tasks, dependent: :destroy

  has_many :role_assignments, class_name: "Assignment", as: :subjectable
  has_many :roles, through: :role_assignments

  validates :name, presence: true

  def permitted_permissions
    roles.map(&:permitted_permissions).flatten.uniq.sort_by(&:priority)
  end
end
