require "application_system_test_case"

class PreparationsTest < ApplicationSystemTestCase
  setup do
    @preparation = preparations(:one)
  end

  test "visiting the index" do
    visit preparations_url
    assert_selector "h1", text: "Preparations"
  end

  test "should create preparation" do
    visit preparations_url
    click_on "New preparation"

    # Ensure new dish field is visible by clearing out the selection (or manually trigger JS)
    find("select#preparation_dish_id").find('option[value=""]').select_option # This ensures no dish is selected

    # Now that the new dish name field should be visible, fill it in
    fill_in "New dish name", with: "Completely New Dish"
    fill_in "New dish description", with: "Description of the new dish"
    fill_in "Date cooked", with: @preparation.date_cooked
    fill_in "Recipe long form", with: @preparation.recipe_long_form
    fill_in "Backstory", with: @preparation.backstory
    click_on "Create Preparation"

    assert_text "Preparation was successfully created"
    click_on "Back"
  end

  test "should update preparation" do
    visit preparation_url(@preparation)
    click_on "Edit this preparation", match: :first

    fill_in "New dish name", with: @preparation.dish_id
    fill_in "Date cooked", with: @preparation.date_cooked
    fill_in "Recipe long form", with: @preparation.recipe_long_form
    fill_in "Backstory", with: @preparation.backstory
    click_on "Update Preparation"

    assert_text "Preparation was successfully updated"
    click_on "Back"
  end

  test "should destroy preparation" do
    visit preparation_url(@preparation)
    click_on "Destroy this preparation", match: :first

    assert_text "Preparation was successfully destroyed"
  end
end
