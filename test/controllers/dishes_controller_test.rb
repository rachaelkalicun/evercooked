# test/controllers/dishes_controller_test.rb
require "test_helper"

class DishesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @existing_dish = dishes(:one)
  end

  test "should get index" do
    get dishes_url
    assert_response :success
  end

  test "should get new for admin" do
    sign_in_admin
    get new_dish_url
    assert_response :success
  end

  test "should restrict access to new for non-admin logged in" do
    sign_in_user
    get new_dish_url
    assert_response :redirect
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_match "You are not authorized", flash[:alert]
  end

  test "should restrict access to new if not logged in" do
    get new_dish_url
    assert_response :redirect
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
  end

  test "should create dish for admin user" do
    sign_in_admin
    assert_difference("Dish.count") do
      post dishes_url, params: { dish: { name: Faker::Lorem.word, description: Faker::Lorem.paragraph } }
    end
    assert_redirected_to dish_url(Dish.last)
  end

  test "should create dish for non admin user" do
    sign_in_user
    assert_difference("Dish.count") do
      post dishes_url, params: { dish: { name: Faker::Lorem.word, description: Faker::Lorem.paragraph } }
    end
    assert_redirected_to dish_url(Dish.last)
  end

  test "should restrict create dish for logged out" do
    post dishes_url, params: { dish: { name: Faker::Lorem.word, description: Faker::Lorem.paragraph } }
    assert_response :redirect
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
  end

  test "should show dish" do
    get dish_url(@existing_dish)
    assert_response :success
  end

  test "should get edit for admin" do
    sign_in_admin
    get edit_dish_url(@existing_dish)
    assert_response :success
  end

  test "should restrict edit for non admin user" do
    sign_in_user
    get edit_dish_url(@existing_dish)
    assert_response :redirect
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_match "You are not authorized", flash[:alert]
  end

  test "should restrict edit for logged out" do
    get edit_dish_url(@existing_dish)
    assert_response :redirect
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
  end

  test "should update dish for admin" do
    sign_in_admin
    patch dish_url(@existing_dish), params: { dish: { name: Faker::Lorem.word, description: Faker::Lorem.paragraph } }
    assert_redirected_to dish_url(@existing_dish)
  end

  test "should restrict update dish for non admin user" do
    sign_in_user
    patch dish_url(@existing_dish), params: { dish: { name: Faker::Lorem.word, description: Faker::Lorem.paragraph } }
    assert_response :redirect
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_match "You are not authorized", flash[:alert]
  end

  test "should restrict update dish for logged out" do
    patch dish_url(@existing_dish), params: { dish: { name: Faker::Lorem.word, description: Faker::Lorem.paragraph } }
    assert_response :redirect
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
  end

  test "should destroy dish for admin" do
    sign_in_admin
    assert_difference("Dish.count", -1) do
      delete dish_url(@existing_dish)
    end
    assert_redirected_to dishes_url
  end

  test "should restrict destroy dish for non admin user" do
    sign_in_user
    delete dish_url(@existing_dish)
    assert_response :redirect
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_match "You are not authorized", flash[:alert]
  end

  test "should restrict destroy dish for logged out" do
    delete dish_url(@existing_dish)
    assert_response :redirect
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
  end
end
