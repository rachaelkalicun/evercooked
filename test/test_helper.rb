ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "pry"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    include Devise::Test::IntegrationHelpers

    def sign_in_admin
      admin ||= users(:one)
      sign_in admin
    end

    def sign_in_user
      user ||= users(:two)
      sign_in user
    end

    def sign_in_user_three
      user ||= users(:three)
      sign_in user
    end

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
