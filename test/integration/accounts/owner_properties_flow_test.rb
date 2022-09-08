require "test_helper"

module Accounts
  class OwnerPropertiesFlowTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_linked_owner = owners(:confirmed_linked_owner)
      @registered_property = properties(:registered_property)
    end

    teardown do
      @confirmed_linked_owner = @registered_property = nil
    end

    test "that linking a property changes account status" do
      unlinked_owner = owners(:confirmed_unlinked_owner)
      sign_in unlinked_owner, scope: :owner

      assert unlinked_owner.unlinked?

      post owners_properties_path, params: {
        property: {
          tower_number: "17",
          flat_number: "2301",
          purchased_on: Time.current - 6.years,
          registration: true,
          primary_ownership: true
        }
      }

      assert unlinked_owner.reload.linked?

      sign_out :owner
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
                registration: true,
                primary_ownership: true
              }
            }
          end
        end

        assert_not_nil Property.last.property_token
      end
    end

    test "that apartment is not created if property details are not complete" do
      authenticated_owner do
        assert_difference "Apartment.count", 0 do
          assert_difference "Property.count", 0 do
            post owners_properties_path, params: {
              property: {
                tower_number: "17",
                flat_number: "2301",
                registered: true,
                primary_owner: true
              }
            }
          end
        end
      end
    end

    test "that property record is not created if apartment details are not complete" do
      authenticated_owner do
        assert_difference "Apartment.count", 0 do
          assert_difference "Property.count", 0 do
            post owners_properties_path, params: {
              property: {
                purchased_on: Time.current - 6.years,
                registered: true,
                primary_owner: true
              }
            }
          end
        end
      end
    end

    test "that linking a property creates memberhip record" do
      authenticated_owner do
        assert_difference "Membership.count" do
          post owners_properties_path, params: {
            property: {
              tower_number: "17",
              flat_number: "2301",
              purchased_on: Time.current - 6.years,
              registration: true,
              primary_ownership: true
            }
          }
        end

        assert Membership.last.under_review?
      end
    end

    test "updating a property record" do
      authenticated_owner do
        put owners_property_path(@registered_property), params: {
          property: {
            purchased_on: @registered_property.purchased_on - 6.weeks
          }
        }

        assert_equal Time.zone.today - 3.years - 6.weeks, @registered_property.reload.purchased_on
      end
    end

    test "that replacing apartment would delete previously linked apartment" do
      authenticated_owner do
        apartment_id = apartments(:apartment_one).id
        assert_equal apartment_id, @registered_property.apartment.id

        put owners_property_path(@registered_property), params: {
          property: {
            tower_number: "7",
            flat_number: "1402"
          }
        }

        assert_not_equal apartment_id, @registered_property.reload.apartment.id
        assert_nil Apartment.find_by(id: apartment_id)
      end
    end

    test "updating apartment does not delete previously linked apartment if it has another linked property" do
      authenticated_owner do
        apartment_id = apartments(:apartment_two).id
        unregistered_property = properties(:unregistered_property)
        assert_equal apartment_id, unregistered_property.apartment.id

        put owners_property_path(unregistered_property), params: {
          property: {
            tower_number: "7",
            flat_number: "1402"
          }
        }

        assert_not_equal apartment_id, unregistered_property.reload.apartment.id
        assert_not_nil Apartment.find_by(id: apartment_id)
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
