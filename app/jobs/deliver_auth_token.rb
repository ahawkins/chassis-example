class DeliverAuthToken
  include Sidekiq::Worker

  def perform(id)
    # FIXME: repo should handle ID coercion
    auth_token = AuthTokenRepo.find id.to_i

    SmsService.deliver auth_token.phone_number, auth_token.code
  end
end
