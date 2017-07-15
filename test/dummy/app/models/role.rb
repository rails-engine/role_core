class Role < RbacCore::Role
  has_many :role_assignments, dependent: :destroy, inverse_of: :role
  has_many :users, through: :role_assignments, source: :subjectable, source_type: "User"
end
