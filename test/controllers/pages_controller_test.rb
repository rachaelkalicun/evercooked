require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pages_index_url
    assert_response :success
    assert_match "Welcome to Evercooked", @response.body
  end

  test "unauthenticated user cannot access dashboard" do
    get pages_dashboard_url
    assert_response :redirect
    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_response :success
    assert_match "Log in", @response.body
    assert_match "Sign up", @response.body
    assert_match "Forgot your password?", @response.body
    assert_match "Remember me", @response.body
    assert_match "You need to sign in or sign up", @response.body
  end

  test "authenticated user cannot access dashboard" do
    user = users(:one)
    sign_in user
    get pages_dashboard_url
    assert_response :success
    assert_match "Welcome to your dashboard", @response.body
    assert_match user.email, @response.body
  end
end
