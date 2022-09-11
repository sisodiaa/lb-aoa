require "test_helper"

class ProfileTest < ActiveSupport::TestCase
  setup do
    @confirmed_linked_owner = profiles(:confirmed_linked_owner)
  end

  teardown do
    @confirmed_linked_owner = nil
  end

  test "that first_name is present" do
    @confirmed_linked_owner.first_name = ""
    assert_not @confirmed_linked_owner.valid?, "First name is not present"
  end

  test "that last_name is present" do
    @confirmed_linked_owner.last_name = ""
    assert_not @confirmed_linked_owner.valid?, "Last name is not present"
  end

  test "full_name concatenates first name, middle name, and last name" do
    assert_equal @confirmed_linked_owner.full_name, "Second Dummy Owner",
      "Full name concatenates first name, middle name, and last name."
  end

  test "reject invalid phone numbers" do
    invalid_phone_numbers = %w[123456789 12345678912345 123-abcd-567]

    invalid_phone_numbers.each do |invalid_phone_number|
      @confirmed_linked_owner.phone_number = invalid_phone_number
      assert_not @confirmed_linked_owner.valid?, "#{invalid_phone_number.inspect} is invalid"
    end
  end

  test "accept valid phone numbers" do
    valid_phone_numbers = %w[9898989898 +91-9898989898]

    valid_phone_numbers.each do |valid_phone_number|
      @confirmed_linked_owner.phone_number = valid_phone_number
      assert @confirmed_linked_owner.valid?, "#{valid_phone_number.inspect} is valid"
    end
  end

  test "#complete?" do
    assert @confirmed_linked_owner.complete?
    assert_not profiles(:owner_seven).complete?
  end
end
