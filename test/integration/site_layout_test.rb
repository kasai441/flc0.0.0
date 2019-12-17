require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test "layout links" do
    get root_path
    assert_template 'home_page/index'
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", signup_path
    assert_no_match /list/, response.body
    assert_no_match /register/, response.body
    get signup_path
    assert_select "title", full_title("ユーザー登録")
  end
end
