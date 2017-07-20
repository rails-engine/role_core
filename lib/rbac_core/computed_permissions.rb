module RbacCore
  class ComputedPermissions
    delegate :each, :map, :to_a, :to_ary, to: :@permissions

    def initialize(permissions = [])
      @permissions = [].concat permissions.to_a
      regroup!
    end

    def concat(permissions)
      @permissions.concat permissions
      regroup!

      self
    end

    def call(context, *args)
      @permissions.each do |permission|
        permission.call(context, *args)
      end

      self
    end

    private

    def regroup!
      @permissions.uniq!
      @permissions.sort_by!(&:priority)
    end
  end
end
