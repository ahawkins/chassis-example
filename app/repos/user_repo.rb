class UserRepo
  extend Chassis::Repo::Delegation

  class UnknownTokenError < StandardError
    def initialize(token)
      @token = token
    end

    def to_s
      "Could not identifiy user with token: #{@token}"
    end
  end

  class << self
    def find_by_token!(token)
      user = query UserWithToken.new(token)
      raise UnknownTokenError, token if user.nil?
      user
    end
  end
end

UserWithToken = Struct.new :token
