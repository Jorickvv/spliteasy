require "test_helper"

class DebtsControllerTest < ActionDispatch::IntegrationTest
  test "should get settle" do
    get debts_settle_url
    assert_response :success
  end
end
