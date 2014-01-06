class SendUserToken
  attr_reader :form

  def initialize(form)
    @form = form
  end

  def run!
    auth_token = AuthToken.create({
      phone_number: form.phone_number,
      code: SecureRandom.hex(6)
    })

    DeliverAuthToken.perform_async auth_token.id.to_s
  end
end
