require "test_helper"

module Management
  module Search
    class ApartmentsFormTest < ActiveSupport::TestCase
      include ActiveModel::Lint::Tests

      setup do
        @model = Management::Search::ApartmentsForm.new({
          tower_number: "25",
          flat_number: "1102"
        })
      end

      teardown do
        @model = nil
      end

      test "tower number is present" do
        @model.tower_number = ""

        assert_not @model.valid?
        assert_equal ["can not be blank"], @model.errors[:tower_number]
      end

      test "flat number is present" do
        @model.flat_number = ""

        assert_not @model.valid?
        assert_equal ["can not be blank"], @model.errors[:flat_number]
      end

      test "#search" do
        apartment = apartments(:apartment_one)

        assert_equal apartment, @model.search.first
      end
    end
  end
end
