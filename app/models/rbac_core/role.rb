module RbacCore
  class Role < ApplicationRecord
    include RbacCore::Concerns::Models::Role
  end
end
