require "test_helper"

module Accounts
  class OwnerPropertiesFlowTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_linked_owner = owners(:confirmed_linked_owner)
    end

    teardown do
      @confirmed_linked_owner = nil
    end

    test "that linking a property also creates a new apartment" do
      authenticated_owner do
        assert_difference "Apartment.count" do
          assert_difference "Property.count" do
            post owners_properties_path, params: {
              property: {
                tower_number: "17",
                flat_number: "2301",
                purchased_on: Time.current - 6.years,
                registered: true,
                primary_owner: true
              }
            }
          end
        end
      end
    end

    private

    def authenticated_owner
      sign_in @confirmed_linked_owner, scope: :owner
      yield if block_given?
      sign_out :owner
    end
  end
end
