require 'test_helper'

class HomePageControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get home_page_show_url
    assert_response :success
    assert_select "title", "ホーム｜Flashcards"
  end

  test "should get root" do
    get root_url
    assert_response :success
  end

end
