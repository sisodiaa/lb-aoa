require "test_helper"

class BidTest < ActiveSupport::TestCase
  setup do
    @bid = bids(:wirewala)
  end

  teardown do
    @bid = nil
  end

  test "that name is present" do
    @bid.name = ""
    assert_not @bid.valid?, "Name is present"
  end

  test "that email is present" do
    @bid.email = ""
    assert_not @bid.valid?, "Email is present"
  end

  test "reject invalid email addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
      foo@bar_baz.com foo@bar+baz.com]

    invalid_addresses.each do |invalid_address|
      @bid.email = invalid_address
      assert_not @bid.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "accept valid email addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
      first.last@foo.jp alice+bob@baz.cn]

    valid_addresses.each do |valid_address|
      @bid.email = valid_address
      assert @bid.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "that attachment is required" do
    assert_not bids(:no_document_wala).valid?, "Attachment is missing"
  end

  test "that token value is unique" do
    assert_not @bid.dup.valid?, "Quotation Token is not unique"
  end

  test "that email is unique per notice" do
    new_bid = Bid.new name: "abc", email: @bid.email, tender_id: @bid.tender_id

    assert_not new_bid.valid?, "Email per notice needs to be unique"
  end
end
