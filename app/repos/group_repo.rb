class GroupRepo
  extend Chassis::Repo::Delegation

  class << self
    def for_user(user, options = { })
      query GroupsForUser.new(options.merge(user: user))
    end
  end
end

class GroupsForUser
  include Chassis::HashInitializer

  attr_accessor :user, :updated_after
end
