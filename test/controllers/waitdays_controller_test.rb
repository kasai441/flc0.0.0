require 'test_helper'

class WaitdaysControllerTest < ActionDispatch::IntegrationTest
  test "should get chart" do
    get waitdays_chart_url
    assert_response :success
  end

end
