class Role < RbacCore::Role
  has_many :assignments, dependent: :destroy, inverse_of: :role
  has_many :subjects, through: :assignments
end
