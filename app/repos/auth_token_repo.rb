class AuthTokenRepo
  extend Chassis::Repo::Delegation

  class UnknownAuthCodeError < StandardError
    def initialize(code)
      @code = code
    end

    def to_s
      %Q{Could not find authentication token with "#{@code}"}
    end
  end

  class << self
    def find_by_code!(code)
      auth_token = query(AuthTokenWithCode.new(code))
      raise UnknownAuthCodeError, code if auth_token.nil?
      auth_token
    end
  end
end

AuthTokenWithCode = Struct.new(:code)
