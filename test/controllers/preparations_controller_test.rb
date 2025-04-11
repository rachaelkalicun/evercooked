# test/controllers/preparations_controller_test.rb
require "test_helper"

class PreparationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @existing_dish     = dishes(:one)
    @existing_holiday  = holidays(:existing_holiday)
    @existing_preparation = preparations(:two)
  end

  test "should show preparation" do
    get preparation_path(@existing_preparation)
    assert_response :success
    assert_select "p", text: /Backstory:/
  end

  test "should get index" do
    get preparations_path
    assert_response :success
    assert_select "h1", "Preparations"
  end

  # creation tests

  test "should create preparation with existing dish and holiday" do
    sign_in_user
    assert_difference("Preparation.count", 1) do
      post preparations_path, params: {
        preparation: {
          dish_id: @existing_dish.id,
          holiday_id: @existing_holiday.id,
          backstory: "Test backstory",
          recipe_long_form: "Test recipe",
          date_cooked: Date.today
        }
      }
    end

    preparation = Preparation.last
    assert_equal @existing_dish, preparation.dish
    assert preparation.occasions.any?, "Expected at least one occasion for the preparation"
    assert_equal "Test backstory", preparation.backstory
  end

  test "should create preparation with new dish and existing holiday" do
    new_dish_name        = Faker::Lorem.word
    new_dish_description = Faker::Lorem.paragraph
    backstory            = Faker::Lorem.paragraph
    recipe_long_form     = Faker::Lorem.paragraph
    sign_in_user

    assert_difference([ "Dish.count", "Preparation.count" ], 1) do
      post preparations_path, params: {
        preparation: {
          new_dish_name: new_dish_name,
          new_dish_description: new_dish_description,
          holiday_id: @existing_holiday.id,
          backstory: backstory,
          recipe_long_form: recipe_long_form,
          date_cooked: Date.today
        }
      }
    end

    preparation = Preparation.last
    assert_equal new_dish_name, preparation.dish.name
    assert_equal new_dish_description, preparation.dish.description
    assert preparation.occasions.any?, "Expected an occasion to be created"
    assert_equal backstory, preparation.backstory
  end

  test "should create preparation with existing dish and new holiday" do
    sign_in_user
    assert_difference([ "Holiday.count", "Occasion.count", "Preparation.count" ], 1) do
      post preparations_path, params: {
        preparation: {
          dish_id: @existing_dish.id,
          new_holiday_name: "New Holiday",
          new_holiday_description: "A newly created holiday",
          backstory: "Test backstory with new holiday",
          recipe_long_form: "Test recipe for new holiday",
          date_cooked: Date.today
        }
      }
    end

    preparation = Preparation.last
    holiday     = Holiday.last
    occasion    = Occasion.last

    assert_equal @existing_dish, preparation.dish
    assert_equal holiday, occasion.holiday
    assert_equal "New Holiday", holiday.name
    assert_equal "A newly created holiday", holiday.description
    assert_equal "Test backstory with new holiday", preparation.backstory
  end

  test "should create preparation with new dish and new holiday" do
    sign_in_user
    assert_difference([ "Dish.count", "Holiday.count", "Occasion.count", "Preparation.count" ], 1) do
      post preparations_path, params: {
        preparation: {
          new_dish_name: "Completely New Dish",
          new_dish_description: "Description of a completely new dish",
          new_holiday_name: "Completely New Holiday",
          new_holiday_description: "Description of a completely new holiday",
          backstory: "Backstory for new dish and holiday",
          recipe_long_form: "Recipe for new dish and holiday",
          date_cooked: Date.today
        }
      }
    end

    dish        = Dish.last
    holiday     = Holiday.last
    preparation = Preparation.last
    occasion    = Occasion.last

    assert dish.valid?, "Dish is not valid: #{dish.errors.full_messages.join(", ")}"
    assert holiday.valid?, "Holiday is not valid: #{holiday.errors.full_messages.join(", ")}"
    assert_equal "Completely New Dish", dish.name
    assert_equal "Description of a completely new dish", dish.description
    assert_equal "Completely New Holiday", holiday.name
    assert_equal "Description of a completely new holiday", holiday.description
    assert_equal dish, preparation.dish
    assert_equal holiday, occasion.holiday
  end

  test "should fail to create preparation without a dish" do
    sign_in_user
    assert_no_difference("Preparation.count") do
      post preparations_path, params: {
        preparation: {
          # No dish_id and no new_dish_* details provided
          holiday_id: @existing_holiday.id,
          backstory: "Backstory with no dish",
          recipe_long_form: "Recipe with no dish",
          date_cooked: Date.today
        }
      }
    end

    assert_redirected_to new_preparation_path
    follow_redirect!
    assert_response :success
    assert_not flash[:alert].empty?, "Expected a flash alert message"
    assert_select "form"
  end

  test "should not create preparation with invalid new dish and new holiday" do
    # Both new dish and new holiday details are blank.
    sign_in_user
    assert_no_difference([ "Dish.count", "Holiday.count", "Occasion.count", "Preparation.count" ]) do
      post preparations_path, params: {
        preparation: {
          new_dish_name: "",
          new_dish_description: "",
          new_holiday_name: "",
          new_holiday_description: "",
          backstory: "Test backstory with invalid dish and holiday",
          recipe_long_form: "Test recipe",
          date_cooked: Date.today
        }
      }
    end

    assert_redirected_to new_preparation_path
    follow_redirect!
    assert_response :success
    assert_not flash[:alert].empty?, "Expected a flash alert message"
    assert_select "form"
  end

  # update/edit tests with authorization

  test "owner can update preparation with valid data" do
    sign_in_user
    patch preparation_path(@existing_preparation), params: {
      preparation: {
        dish_id: @existing_dish.id,
        backstory: "Updated backstory as owner",
        recipe_long_form: "Updated recipe as owner",
        date_cooked: Date.tomorrow,
        holiday_id: @existing_holiday.id
      }
    }
    assert_redirected_to preparation_path(@existing_preparation)
    @existing_preparation.reload
    assert_equal "Updated backstory as owner", @existing_preparation.backstory
    assert_equal "Updated recipe as owner", @existing_preparation.recipe_long_form
    assert_equal Date.tomorrow, @existing_preparation.date_cooked
    assert_equal @existing_dish.id, @existing_preparation.dish_id
  end

  test "admin can update preparation regardless of ownership" do
    sign_in_admin
    assert_not_equal @existing_preparation.user, users(:one)
    patch preparation_path(@existing_preparation), params: {
      preparation: {
        dish_id: @existing_dish.id,
        backstory: "Updated backstory as admin",
        recipe_long_form: "Updated recipe as admin",
        date_cooked: Date.tomorrow,
        holiday_id: @existing_holiday.id
      }
    }
    assert_redirected_to preparation_path(@existing_preparation)
    @existing_preparation.reload
    assert_equal "Updated backstory as admin", @existing_preparation.backstory
    assert_equal "Updated recipe as admin", @existing_preparation.recipe_long_form
    assert_equal Date.tomorrow, @existing_preparation.date_cooked
    assert_equal @existing_dish.id, @existing_preparation.dish_id
  end

  test "non-owner, non-admin cannot update preparation" do
    sign_in_user_three
    assert_not_equal @existing_preparation.user, users(:three)
    patch preparation_path(@existing_preparation), params: {
      preparation: {
        backstory: "Unauthorized update",
        recipe_long_form: "Unauthorized update",
        date_cooked: Date.tomorrow
      }
    }
    assert_response :redirect
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_match "You are not authorized", flash[:alert]
  end

  test "should not update preparation when not logged in" do
    patch preparation_path(@existing_preparation), params: {
      preparation: {
        backstory: "Update without login",
        recipe_long_form: "Update without login",
        date_cooked: Date.tomorrow
      }
    }
    assert_redirected_to new_user_session_path
  end

  test "should get edit for owner" do
    sign_in_user
    get edit_preparation_path(@existing_preparation)
    assert_response :success
    assert_select "form"
  end

  test "admin should get edit for preparation they do not own" do
    sign_in_admin
    get edit_preparation_path(@existing_preparation)
    assert_response :success
    assert_select "form"
  end

  test "non-owner, non-admin should not get edit" do
    sign_in_user_three
    get edit_preparation_path(@existing_preparation)
    assert_response :redirect
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_match "You are not authorized", flash[:alert]
  end

  test "should not get edit when not logged in" do
    get edit_preparation_path(@existing_preparation)
    assert_redirected_to new_user_session_path
  end

  test "should update preparation with new dish and new holiday" do
    sign_in_user
    patch preparation_path(@existing_preparation), params: {
      preparation: {
        new_dish_name: "New Dish",
        new_dish_description: "Description of new dish",
        new_holiday_name: "New Holiday",
        new_holiday_description: "Description of new holiday",
        backstory: "Updated backstory",
        recipe_long_form: "Updated recipe",
        date_cooked: Date.tomorrow
      }
    }
    assert_redirected_to preparation_path(@existing_preparation)
    @existing_preparation.reload
    assert_equal "New Dish", @existing_preparation.dish.name
    assert_equal "Description of new dish", @existing_preparation.dish.description
    assert_equal "New Holiday", @existing_preparation.occasions.first.holiday.name
    assert_equal "Description of new holiday", @existing_preparation.occasions.first.holiday.description
    assert_equal "Updated backstory", @existing_preparation.backstory
    assert_equal Date.tomorrow, @existing_preparation.date_cooked
  end

  test "should not update preparation with invalid new holiday" do
    sign_in_user
    patch preparation_path(@existing_preparation), params: {
      preparation: {
        new_holiday_name: "",
        new_holiday_description: "",
        backstory: "Test backstory",
        recipe_long_form: "Test recipe",
        date_cooked: Date.today
      }
    }
    assert_response :unprocessable_entity
    assert_select "form"
  end

  # destroy tests with authorization

  test "owner can destroy preparation" do
    sign_in_user
    assert_difference("Preparation.count", -1) do
      delete preparation_path(@existing_preparation)
    end
    assert_redirected_to preparations_path
  end

  test "admin can destroy preparation" do
    sign_in_admin
    assert_difference("Preparation.count", -1) do
      delete preparation_path(@existing_preparation)
    end
    assert_redirected_to preparations_path
  end

  test "non-owner, non-admin cannot destroy preparation" do
    sign_in_user_three
    assert_not_equal @existing_preparation.user, users(:three)
    delete preparation_path(@existing_preparation)
    assert_response :redirect
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
    assert_match "You are not authorized", flash[:alert]
  end

  test "should not destroy preparation when not logged in" do
    delete preparation_path(@existing_preparation)
    assert_redirected_to new_user_session_path
  end
end
