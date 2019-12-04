require 'test_helper'

class HomePageControllerTest < ActionDispatch::IntegrationTest
  test "should get root" do
    get root_path
    assert_response :success
    assert_select "title", full_title("ホーム")
  end

end
