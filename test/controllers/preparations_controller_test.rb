require "test_helper"

class PreparationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @existing_dish = dishes(:one)
    @existing_holiday = holidays(:existing_holiday)
    @existing_occasion = occasions(:existing_occasion)
  end

  test "should create preparation with existing dish and holiday" do
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
    assert_equal @existing_occasion, preparation.occasions.first
    assert_equal "Test backstory", preparation.backstory
  end

  test "should create preparation with new dish and existing holiday" do
    new_dish_name = Faker::Lorem.word
    new_dish_description = Faker::Lorem.paragraph
    backstory = Faker::Lorem.paragraph
    recipe_long_form = Faker::Lorem.paragraph

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
    assert_equal @existing_occasion, preparation.occasions.first
    assert_equal backstory, preparation.backstory
  end

  test "should create preparation with existing dish and new holiday" do
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
    holiday = Holiday.last
    occasion = Occasion.last

    assert_equal @existing_dish, preparation.dish
    assert_equal holiday, occasion.holiday
    assert_equal "New Holiday", holiday.name
    assert_equal "A newly created holiday", holiday.description
    assert_equal "Test backstory with new holiday", preparation.backstory
  end

test "should create preparation with new dish and new holiday" do
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

  dish = Dish.last
  holiday = Holiday.last

  assert dish.valid?, "Dish is not valid: #{dish.errors.full_messages.join(", ")}"
  assert holiday.valid?, "Holiday is not valid: #{holiday.errors.full_messages.join(", ")}"

  preparation = Preparation.last
  occasion = Occasion.last

  assert_equal "Completely New Dish", dish.name
  assert_equal "Description of a completely new dish", dish.description
  assert_equal "Completely New Holiday", holiday.name
  assert_equal "Description of a completely new holiday", holiday.description
  assert_equal dish, preparation.dish
  assert_equal occasion, preparation.occasions.first
  assert_equal holiday, occasion.holiday
end

test "should not create preparation with missing required fields" do
  assert_no_difference("Preparation.count") do
    post preparations_path, params: {
      preparation: {
        backstory: "",
        recipe_long_form: "",
        date_cooked: ""
      }
    }
  end

  assert_redirected_to new_preparation_path
  follow_redirect!

  assert_not flash[:alert].empty?, "Expected a flash alert message"
  assert_select "form"
end

test "should update preparation with valid data" do
  preparation = preparations(:one)
  existing_dish = dishes(:one)

  patch preparation_path(preparation), params: {
    preparation: {
      dish_id: existing_dish.id,
      backstory: "Updated backstory",
      recipe_long_form: "Updated recipe",
      date_cooked: Date.tomorrow,
      holiday_id: @existing_holiday.id
    }
  }

  assert_redirected_to preparation_path(preparation)
  preparation.reload
  assert_equal "Updated backstory", preparation.backstory
  assert_equal "Updated recipe", preparation.recipe_long_form
  assert_equal Date.tomorrow, preparation.date_cooked
  assert_equal existing_dish.id, preparation.dish_id
end


test "should not update preparation with invalid data" do
  preparation = preparations(:one)
  patch preparation_path(preparation), params: {
    preparation: {
      backstory: "",
      recipe_long_form: "",
      date_cooked: ""
    }
  }

  assert_response :unprocessable_entity
  assert_select "form"
end

test "should show preparation" do
  preparation = preparations(:one)
  get preparation_path(preparation)
  assert_response :success
  assert_select "p", text: "Backstory: #{preparation.backstory}"
end

test "should get edit" do
  preparation = preparations(:one)
  get edit_preparation_path(preparation)
  assert_response :success
  assert_select "form"
end

  test "should fail to create preparation without a dish" do
    assert_no_difference("Preparation.count") do
      post preparations_path, params: {
        preparation: {
          holiday_id: @existing_holiday.id,
          backstory: "Backstory with no dish",
          recipe_long_form: "Recipe with no dish",
          date_cooked: Date.today
        }
      }
    end

    assert_redirected_to new_preparation_path
    follow_redirect!

    assert_not flash[:alert].empty?, "Expected a flash alert message"
    assert_select "form"
  end

  test "should not create preparation with invalid new dish and new holiday" do
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

    assert_not flash[:alert].empty?, "Expected a flash alert message"
    assert_select "form"
  end

  test "should not create preparation with missing dish and holiday" do
    assert_no_difference("Preparation.count") do
      post preparations_path, params: {
        preparation: {
          backstory: "Test backstory with missing dish and holiday",
          recipe_long_form: "Test recipe",
          date_cooked: Date.today
        }
      }
    end

    assert_redirected_to new_preparation_path
    follow_redirect!

    assert_not flash[:alert].empty?, "Expected a flash alert message"
    assert_select "form"
  end

  test "should update preparation with new dish and new holiday" do
    preparation = preparations(:one)
    new_dish_name = Faker::Lorem.word
    new_dish_description = Faker::Lorem.paragraph
    new_holiday_name = Faker::Lorem.word
    new_holiday_description = Faker::Lorem.paragraph
    backstory = Faker::Lorem.paragraph
    recipe_long_form = Faker::Lorem.paragraph

    assert_difference([ "Dish.count", "Holiday.count", "Occasion.count" ]) do
      patch preparation_path(preparation), params: {
        preparation: {
          new_dish_name: new_dish_name,
          new_dish_description: new_dish_description,
          new_holiday_name: new_holiday_name,
          new_holiday_description: new_holiday_description,
          backstory: backstory,
          recipe_long_form: recipe_long_form,
          date_cooked: Date.tomorrow
        }
      }
    end

    preparation.reload
    assert_equal new_dish_name, preparation.dish.name
    assert_equal new_dish_description, preparation.dish.description
    assert_equal new_holiday_name, preparation.occasions.first.holiday.name
    assert_equal new_holiday_description, preparation.occasions.first.holiday.description
    assert_equal backstory, preparation.backstory
    assert_equal Date.tomorrow, preparation.date_cooked
  end

  test "should not update preparation with invalid new holiday" do
    preparation = preparations(:one)

    patch preparation_path(preparation), params: {
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

  test "should update preparation with valid new dish and new holiday" do
    preparation = preparations(:one)

    assert_difference("Dish.count", 1) do
      assert_difference("Holiday.count", 1) do
        patch preparation_path(preparation), params: {
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
      end
    end

    preparation.reload
    assert_equal "New Dish", preparation.dish.name
    assert_equal "Description of new dish", preparation.dish.description
    assert_equal "New Holiday", preparation.occasions.first.holiday.name
    assert_equal "Description of new holiday", preparation.occasions.first.holiday.description
    assert_equal "Updated backstory", preparation.backstory
    assert_equal Date.tomorrow, preparation.date_cooked
  end

  test "should destroy preparation" do
    preparation = preparations(:one)
    assert_difference("Preparation.count", -1) do
      delete preparation_path(preparation)
    end

    assert_redirected_to preparations_path
  end
end
