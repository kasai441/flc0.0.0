# frozen_string_literal: true

require 'test_helper'

class HomePageControllerTest < ActionDispatch::IntegrationTest
  test 'should get root' do
    get root_path
    assert_response :success
    assert_select 'title', full_title('ホーム')
  end

  # if logged in

  # if not logged in, if cookies
end
