require 'test_helper'

class ChatsControllerTest < ActionDispatch::IntegrationTest
  test "should get welcome" do
    get chats_welcome_url
    assert_response :success
  end

  test "should get show" do
    get chats_show_url
    assert_response :success
  end

end
