require "test_helper"

module Management
  module Search
    class OwnersFormTest < ActiveSupport::TestCase
      include ActiveModel::Lint::Tests

      setup do
        @model = Management::Search::OwnersForm.new({
          email: "owner_two@example.com",
          first_name: "Second",
          last_name: "Owner"
        })
      end

      teardown do
        @model = nil
      end

      test "that email, or first name, or last name is present" do
        @model.email = ""
        @model.first_name = ""
        @model.last_name = ""

        assert_not @model.valid?
        assert_equal ["Email address, First Name, or Last Name is required"], @model.errors[:base]
      end

      test "search if only email is given" do
        @model.first_name = ""
        @model.last_name = ""

        assert_equal 1, @model.search.count
        assert_includes @model.search, Owner.find_by(email: "owner_two@example.com"), "Result not found"
      end

      test "search if only first name is given" do
        @model.email = ""
        @model.last_name = ""

        assert_equal 1, @model.search.count
        assert_includes @model.search, Owner.find_by(email: "owner_two@example.com"), "Result not found"
      end

      test "search if only last name is given" do
        @model.email = ""
        @model.first_name = ""

        assert_equal 7, @model.search.count
        assert_equal Owner.all.to_a, @model.search.to_a, "Results not found"
      end
    end
  end
end
