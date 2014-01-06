require_relative '../../test_helper'

class GetSelfTest  < AcceptanceTestCase
  attr_reader :user

  def setup
    super
    @user = create :user
  end

  def test_returns_the_user_as_json
    get '/self', { }, 'HTTP_X_TOKEN' => user.token
    assert_equal 200, last_response.status
  end
end
