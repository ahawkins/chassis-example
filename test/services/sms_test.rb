require_relative '../test_helper'

class SmsServiceTest < MiniTest::Unit::TestCase
  attr_reader :sms

  def account_sid
    'account_sid'
  end

  def auth_token
    'auth_token'
  end

  def from_number
    '+32482314'
  end

  def to_number
    '+23913831'
  end

  def sms
    SmsService
  end

  def setup
    SmsService.backend = SmsService::Twilio.new account_sid, auth_token, from_number
  end

  def test_sends_sms_using_twilio
    stub_request(:post, "https://#{account_sid}:#{auth_token}@api.twilio.com/2010-04-01/Accounts/#{account_sid}/SMS/Messages.json").
      with(:body => { "Body" => "hi", "From" => from_number , "To" => to_number }).
      to_return(:status => 201, :body => "", :headers => {})

    sms.deliver to_number, 'hi'
  end

  def test_raises_an_error_when_call_fails
    stub_request(:post, /twilio/).to_return({
      status: 500,
      headers: {
        'Content-Type' => 'application/json'
      },
      body: JSON.dump({
        status: 500,
        message: 'Internal Failure'
      })
    })

    assert_raises SmsService::DeliveryError do
      sms.deliver to_number, 'hi'
    end
  end

  def test_handles_timeouts
    stub_request(:post, /twilio/).to_timeout

    assert_raises SmsService::DeliveryError do
      sms.deliver to_number, 'hi'
    end
  end
end
