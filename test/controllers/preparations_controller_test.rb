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
    assert_difference([ "Dish.count", "Preparation.count" ], 1) do
      post preparations_path, params: {
        preparation: {
          new_dish_name: "New Dish",
          new_dish_description: "A newly created dish",
          holiday_id: @existing_holiday.id,
          backstory: "Test backstory with new dish",
          recipe_long_form: "Test recipe for new dish",
          date_cooked: Date.today
        }
      }
    end

    preparation = Preparation.last
    assert_equal "New Dish", preparation.dish.name
    assert_equal "A newly created dish", preparation.dish.description
    assert_equal @existing_occasion, preparation.occasions.first
    assert_equal "Test backstory with new dish", preparation.backstory
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

  # Check for Dish and Holiday
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

  assert_response :unprocessable_entity
  assert_select "form" # Ensure the form is rendered again
end

test "should update preparation with valid data" do
  preparation = preparations(:one)
  existing_dish = dishes(:one)  # Ensure the dish exists in fixtures
  existing_holiday = holidays(:existing_holiday)  # Ensure a holiday exists in fixtures
  existing_occasion = occasions(:existing_occasion) # Ensure an occasion is tied to this holiday

  # Associate the preparation with an existing occasion for the holiday
  preparation.occasions << existing_occasion

  patch preparation_path(preparation), params: {
    preparation: {
      dish_id: existing_dish.id,
      backstory: "Updated backstory",
      recipe_long_form: "Updated recipe",
      date_cooked: Date.tomorrow,
      holiday_id: existing_holiday.id  # Provide holiday_id to satisfy new logic
    }
  }

  assert_redirected_to preparation_path(preparation)
  preparation.reload
  assert_equal "Updated backstory", preparation.backstory
  assert_equal "Updated recipe", preparation.recipe_long_form
  assert_equal Date.tomorrow, preparation.date_cooked
  assert_equal existing_dish.id, preparation.dish_id  # Ensure dish is updated
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
  assert_select "form" # Ensure the form is rendered again
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

    assert_response :unprocessable_entity
    assert_select "form" # Ensure the form is rendered again
  end

  # Test that preparation can't be created with a new dish and a new holiday if both are invalid
  test "should not create preparation with invalid new dish and new holiday" do
    assert_no_difference([ "Dish.count", "Holiday.count", "Occasion.count", "Preparation.count" ]) do
      post preparations_path, params: {
        preparation: {
          new_dish_name: "",  # Invalid dish name
          new_dish_description: "",
          new_holiday_name: "",  # Invalid holiday name
          new_holiday_description: "",
          backstory: "Test backstory with invalid dish and holiday",
          recipe_long_form: "Test recipe",
          date_cooked: Date.today
        }
      }
    end

    assert_response :unprocessable_entity
    assert_select "form"
  end

  # Test that preparation can't be created if dish and holiday are both missing
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

    assert_response :unprocessable_entity
    assert_select "form"
  end

  # Test that preparation can be updated with a new dish and a new holiday
  test "should update preparation with new dish and new holiday" do
    preparation = preparations(:one)
    existing_occasion = occasions(:existing_occasion)

    assert_difference([ "Dish.count", "Holiday.count", "Occasion.count" ]) do
      patch preparation_path(preparation), params: {
        preparation: {
          new_dish_name: "Updated Dish",
          new_dish_description: "Updated dish description",
          new_holiday_name: "Updated Holiday",
          new_holiday_description: "Updated holiday description",
          backstory: "Updated backstory",
          recipe_long_form: "Updated recipe",
          date_cooked: Date.tomorrow
        }
      }
    end

    preparation.reload
    assert_equal "Updated Dish", preparation.dish.name
    assert_equal "Updated dish description", preparation.dish.description
    assert_equal "Updated Holiday", preparation.occasions.first.holiday.name
    assert_equal "Updated holiday description", preparation.occasions.first.holiday.description
    assert_equal "Updated backstory", preparation.backstory
    assert_equal Date.tomorrow, preparation.date_cooked
  end

  # Test that preparation can't be updated if a new holiday is invalid
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

  # Test that preparation can be updated with valid new data
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

  # Test that the preparation destroy action works
  test "should destroy preparation" do
    preparation = preparations(:one)
    assert_difference("Preparation.count", -1) do
      delete preparation_path(preparation)
    end

    assert_redirected_to preparations_path
  end
end
