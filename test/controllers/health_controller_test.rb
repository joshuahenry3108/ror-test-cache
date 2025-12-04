require "test_helper"

class HealthControllerTest < ActionDispatch::IntegrationTest
  test "should get health status" do
    get "/health"
    assert_response :success

    body = JSON.parse(@response.body)
    assert_equal "ok", body["status"]
  end
end
