class GroupRepo
  extend Chassis::Repo::Delegation

  class << self
    def for_user(user, options = { })
      query GroupsForUser.new(options.merge(user: user))
    end
  end
end

class GroupsForUser
  include Chassis::Initializable

  attr_accessor :user, :updated_after
end
