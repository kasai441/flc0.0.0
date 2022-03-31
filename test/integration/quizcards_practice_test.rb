require 'test_helper'

class QuizcardsPracticeTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @no_card_user = users(:archer)
  end


  # test "temp practice without login" do
    # get root_path
    # assert_template 'home_page/index'
    # assert_not is_logged_in?
    # assert_equal @user.name, assigns(:user).name
    # assert_select 'a[href=?]', practice_path, count: 1
    # get practice_path
    # assert_not is_logged_in?
    # assert_equal @user.name, assigns(:user).name
    # assert assigns(:user).quizcards
    # assert_equal 3, assigns(:quizcards_today).count
    # assert_template 'quizcards/practice'
  # end

  test "practice with login having cards" do
    get root_path
    log_in_as @user
    get root_path
    assert_template 'home_page/index'
    assert is_logged_in?
    assert_equal @user.name, assigns(:user).name
    assert_select 'a[href=?]', practice_path, count: 1
    get practice_path
    assert is_logged_in?
    assert_equal @user.name, assigns(:user).name
    assert assigns(:user).quizcards
    assert_equal 3, assigns(:quizcards_today).count
    assert_template 'quizcards/practice'
  end

  test "practice with login not having cards" do
    get root_path
    log_in_as @no_card_user
    get root_path
    assert_template 'home_page/index'
    assert is_logged_in?
    assert_equal @no_card_user.name, assigns(:user).name
    assert_not assigns(:user).quizcards.any?
    assert_not assigns(:quizcards_today)
    assert_select 'a[href=?]', practice_path, count: 0
    get practice_path
    assert is_logged_in?
    assert_equal @no_card_user.name, assigns(:user).name
    assert_not assigns(:user).quizcards.any?
    assert_not assigns(:quizcards_today)
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'home_page/index'
  end
end
