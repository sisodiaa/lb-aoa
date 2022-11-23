require "test_helper"

module Accounts
  module Owners
    class PropertyFormTest < ActiveSupport::TestCase
      include ActiveModel::Lint::Tests

      setup do
        @model = Accounts::Owners::PropertyForm.new({
          tower_number: "17",
          flat_number: "2301",
          purchased_on: Time.zone.today - 6.years,
          registration: true,
          primary_ownership: true
        })
      end

      teardown do
        @model = nil
      end

      test "that tower number is present" do
        @model.tower_number = ""
        assert_not @model.valid?
        assert_equal ["can't be blank"], @model.errors[:tower_number]
      end

      test "that flat number is present" do
        @model.flat_number = ""
        assert_not @model.valid?
        assert_equal ["can't be blank"], @model.errors[:flat_number]
      end

      test "that purchased on date should be in past" do
        @model.purchased_on = Time.zone.today + 2.years
        assert_not @model.valid?
        assert_equal ["date is invalid as it is set in future"], @model.errors[:purchased_on]
      end

      test "that property registration status is present" do
        @model.registration = nil
        assert_not @model.valid?
        assert_equal ["status should be either \"Yes\" or \"No\""], @model.errors[:registration]
      end

      test "that primary ownership status is present" do
        @model.primary_ownership = nil
        assert_not @model.valid?
        assert_equal ["status should be either \"Yes\" or \"No\""], @model.errors[:primary_ownership]
      end
    end
  end
end
