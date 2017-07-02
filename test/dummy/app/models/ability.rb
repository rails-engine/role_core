class Ability
  include CanCan::Ability

  def initialize(user)
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    user.permitted_permissions.each do |permission|
      permission.call(self, user)
    end
  end
end
