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

  class UnknownPhoneNumber < StandardError
    def initialize(phone_number)
      @phone_number = phone_number
    end

    def to_s
      "Could not identifiy user with phone number: #{@phone_number}"
    end
  end

  class << self
    def find_by_token!(token)
      user = query UserWithToken.new(token)
      raise UnknownTokenError, token if user.nil?
      user
    end

    def find_by_phone_number!(phone_number)
      user = query UserWithPhoneNumber.new(phone_number)
      raise UnknownPhoneNumber, phone_number if user.nil?
      user
    end
  end
end

UserWithToken = Struct.new :token
UserWithPhoneNumber = Struct.new :phone_number
