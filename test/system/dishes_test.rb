require "application_system_test_case"

class DishesTest < ApplicationSystemTestCase
  setup do
    @dish = dishes(:one)
  end

  test "visiting the index" do
    visit dishes_url
    assert_selector "h1", text: "Dishes"
  end

  test "should create dish for admin" do
    sign_in_admin
    visit dishes_url
    click_on "New dish"

    fill_in "Name", with: Faker::Lorem.word
    fill_in_rich_text_area "dish_description", with: Faker::Lorem.paragraph
    click_on "Create Dish"

    assert_text "Dish was successfully created"
    click_on "Back"
  end

  test "should not see a link for create dish for non admin user" do
    sign_in_user
    visit dishes_url
    assert_no_link "New dish"
    assert_no_button "New dish"
  end

  test "should not see a link for create dish for logged out" do
    visit dishes_url
    assert_no_link "New dish"
    assert_no_button "New dish"
  end

  test "should update dish for admin" do
    sign_in_admin
    visit dish_url(@dish)
    click_on "Edit this dish", match: :first

    fill_in "Name", with: @dish.name
    click_on "Update Dish"

    assert_text "Dish was successfully updated"
    click_on "Back"
  end

  test "should not see a link for edit dish for non admin user" do
    sign_in_user
    visit dish_url(@dish)
    assert_no_link "Edit this dish"
    assert_no_button "Edit this dish"
  end

  test "should not see a link for edit dish for logged out" do
    visit dish_url(@dish)
    assert_no_link "Edit this dish"
    assert_no_button "Edit this dish"
  end

  test "should destroy Dish for admin user" do
    sign_in_admin
    visit dish_url(@dish)
    click_on "Destroy this dish", match: :first

    assert_text "Dish was successfully destroyed"
  end

  test "should not see a link for destroy Dish for non admin user" do
    sign_in_user
    visit dish_url(@dish)
    assert_no_link "Destroy this dish"
    assert_no_button "Destroy this dish"
  end

  test "should not see a link for destroy Dish for logged out" do
    visit dish_url(@dish)
    assert_no_link "Destroy this dish"
    assert_no_button "Destroy this dish"
  end
end
