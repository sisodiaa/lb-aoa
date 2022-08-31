require "test_helper"

class ApartmentTest < ActiveSupport::TestCase
  setup do
    @apartment = apartments(:apartment_one)
  end

  teardown do
    @apartment = nil
  end

  test "that tower number is present" do
    @apartment.tower_number = ""
    assert_not @apartment.valid?, "Tower number is not present"
  end

  test "that tower number is valid" do
    @apartment.tower_number = "11"
    assert_not @apartment.valid?, "Tower number is not valid"

    @apartment.tower_number = "13"
    assert_not @apartment.valid?, "Tower number is not valid"

    @apartment.tower_number = "30"
    assert_not @apartment.valid?, "Tower number is not valid"

    @apartment.tower_number = "one"
    assert_not @apartment.valid?, "Tower number is not valid"
  end

  test "that flat number is present" do
    @apartment.flat_number = ""
    assert_not @apartment.valid?, "Flat number is not present"
  end
end
