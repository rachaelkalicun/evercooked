require "test_helper"

class DishTest < ActiveSupport::TestCase
  def setup
    @dish = Dish.new(name: "Test Dish", description: "A sample dish")
  end

  test "should be valid with valid attributes" do
    assert @dish.valid?
  end

  test "should be invalid without a name" do
    @dish.name = nil
    assert_not @dish.valid?
    assert_includes @dish.errors[:name], "can't be blank"
  end

  test "should be invalid without a description" do
    @dish.description = nil
    assert_not @dish.valid?
    assert_includes @dish.errors[:description], "can't be blank"
  end

  test "should enforce unique name" do
    @dish.save
    duplicate_dish = Dish.new(name: "Test Dish", description: "Another dish")
    assert_not duplicate_dish.valid?
    assert_includes duplicate_dish.errors[:name], "has already been taken"
  end

  test "should have many preparations" do
    assert_respond_to @dish, :preparations
  end

  test "should accept nested attributes for preparations" do
    assert_respond_to @dish, :preparations_attributes=
  end

  test "should have rich text body" do
    assert_respond_to @dish, :body
  end
end
