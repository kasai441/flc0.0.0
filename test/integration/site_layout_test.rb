require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.first
  end

  test "layout links without login" do
    get root_path
    assert_template 'home_page/index'
    assert_select "a[href=?]", root_path, count:2
    assert_select "a[href=?]", register_path, count:0
    assert_select "a[href=?]", signup_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", login_path
    get signup_path
    assert_select "title", full_title("ユーザー登録")
  end

  test "layout links with login" do
    log_in_as(@user)
    get root_path
    assert_template 'home_page/index'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", register_path, count: 1
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", signup_path, count: 0
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", logout_path
  end

end
