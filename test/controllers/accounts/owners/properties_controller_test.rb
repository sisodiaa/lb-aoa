require "test_helper"

module Accounts
  module Owners
    class PropertiesControllerTest < ActionDispatch::IntegrationTest
      setup do
        @confirmed_linked_owner = owners(:confirmed_linked_owner)
      end

      teardown do
        @confirmed_linked_owner = nil
      end

      test "#authenticate_owner!" do
        get owners_properties_path
        assert_redirected_to new_owner_session_path
      end

      test "creating property" do
        authenticated_owner do
          post owners_properties_path, params: {
            property: {
              tower_number: "17",
              flat_number: "2301",
              purchased_on: Time.current - 6.years,
              registration: true,
              primary_ownership: true
            }
          }

          assert_redirected_to owners_properties_path
        end
      end

      test "that only owner can access his or her  property record" do
        different_owner = owners(:confirmed_linked_co_owner)
        owners_property = properties(:registered_property)
        sign_in different_owner, scope: :owner

        get owners_property_path(owners_property)

        assert_redirected_to root_path

        sign_out :owner
      end

      private

      def authenticated_owner
        sign_in @confirmed_linked_owner, scope: :owner
        yield if block_given?
        sign_out :owner
      end
    end
  end
end
