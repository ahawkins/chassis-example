class SendUserToken
  attr_reader :form

  def initialize(form)
    @form = form
  end

  def run!
    form.validate!

    auth_token = AuthToken.create({
      phone_number: form.phone_number,
      code: (rand * 10**6).to_i.to_s
    })

    SmsService.deliver form.phone_number, auth_token.code
  end
end
