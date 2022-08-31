require "test_helper"

class PropertyTest < ActiveSupport::TestCase
  setup do
    @registered_property = properties(:registered_property)
  end

  teardown do
    @registered_property = nil
  end

  test "that purchase date is present" do
    @registered_property.purchased_on = nil
    assert_not @registered_property.valid?, "Purchase date is not present"
  end

  test "that purchase date is not set in future" do
    @registered_property.purchased_on = Time.zone.today + 2.years
    assert_not @registered_property.valid?, "Purchase date is not in past"
  end

  test "that registration status is either true or false" do
    @registered_property.registered = nil
    assert_not @registered_property.valid?, "Registration status is neither true nor false"
  end

  test "that ownership status is either true or false" do
    @registered_property.primary_owner = nil
    assert_not @registered_property.valid?, "Ownership status is neither true nor false"
  end
end
