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
    visit preparations_url(@preparation)
    click_on "New preparation"

    fill_in "preparation_new_dish_name", with: Faker::Lorem.word
    fill_in "preparation_new_dish_description", with: Faker::Lorem.paragraph
    fill_in "preparation_new_holiday_name", with: Faker::Lorem.word

    click_on "Save Preparation"
    assert_text "Preparation successfully created."
  end

  test "should update preparation" do
    visit preparation_url(@preparation)
    click_on "Edit this preparation", match: :first
    fill_in "preparation_new_dish_name", with: "Completely New Dish"
    fill_in "preparation_new_holiday_name", with: "New Holiday"
    fill_in "preparation_date_cooked", with: @preparation.date_cooked
    fill_in "preparation_recipe_long_form", with: @preparation.recipe_long_form
    fill_in "preparation_backstory", with: @preparation.backstory
    click_on "Save Preparation"

    assert_text "Preparation successfully updated."
  end

  test "should destroy preparation" do
    visit preparation_url(@preparation)
    click_on "Destroy this preparation", match: :first

    assert_text "Preparation was successfully destroyed"
  end
end
