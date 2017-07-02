require 'test_helper'

class SessionControllerTest < ActionDispatch::IntegrationTest
  test "should get sign_in_as" do
    get session_sign_in_as_url
    assert_response :success
  end

end
