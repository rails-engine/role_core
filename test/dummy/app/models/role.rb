class Role < RbacCore::Role
  has_many :role_assignments, dependent: :destroy
  has_many :users, through: :role_assignments
end
