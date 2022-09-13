require "test_helper"

module Management
  module Search
    class OwnersFormTest < ActiveSupport::TestCase
      include ActiveModel::Lint::Tests

      setup do
        @model = Management::Search::OwnersForm.new({
          email: "owner_two@example.com"
        })
      end

      teardown do
        @model = nil
      end

      test "email is present" do
        @model.email = ""

        assert_not @model.valid?
        assert_equal ["can't be blank"], @model.errors[:email]
      end
    end
  end
end
