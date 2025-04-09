require "application_system_test_case"

class DeviseAuthTest < ApplicationSystemTestCase
  test "home page works for unauthenticated user" do
    visit root_path
    assert_text "Welcome to Evercooked"
  end

  test "unauthenticated user cannot access dashboard" do
    visit pages_dashboard_path
    assert_text "You need to sign in or sign up before continuing."
    assert_text "Log in"
    assert_text "Sign up"
    assert_text "Forgot your password?"
    assert_text "Remember me"
    assert_text "You need to sign in or sign up before continuing."
  end

  test "sign in existing user and see dashboard" do
    visit root_path
    assert_text "Welcome to Evercooked"
    sign_in users(:one)
    visit pages_dashboard_path
    assert_text "Welcome to your dashboard, #{users(:one).email}"
  end

  test "sign up new user and see dashboard" do
    email = Faker::Internet.email
    password = Faker::Internet.password(min_length: 8)
    user = User.create(email: email, password: password)
    visit pages_dashboard_path
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_button "Log in"
    assert_current_path pages_dashboard_path
    assert_text "Welcome to your dashboard, #{email}"
  end
end
