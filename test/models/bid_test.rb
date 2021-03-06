require "test_helper"

class BidTest < ActiveSupport::TestCase
  setup do
    @current_tender = tenders(:barb_wire)
    @bid = bids(:wirewala)
  end

  teardown do
    @bid = @current_tender = nil
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
    attach_file_to_record(
      @bid.build_document.file,
      "sheet.xlsx",
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )

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

  test "that only excel file can be attached" do
    attach_file_to_record(
      @bid.build_document.file,
      "sheet.xlsx",
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )
    assert @bid.valid?

    attach_file_to_record(
      @bid.build_document.file,
      "vim-cheatsheet.pdf",
      "application/pdf"
    )
    assert @bid.valid?

    attach_file_to_record @bid.build_document.file, "square.png", "image/png"
    assert_not @bid.valid?, "Only excel files are allowed"
  end

  test "that unique quotation token is generated for new token" do
    new_bid = @current_tender.bids.create name: "abc", email: "em@i.l"
    attach_file_to_record(
      new_bid.build_document.file,
      "sheet.xlsx",
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )

    assert_nil new_bid.quotation_token
    new_bid.save
    assert_not_nil new_bid.quotation_token
  end

  test "that token value is unique" do
    new_bid = @bid.dup
    attach_file_to_record(
      new_bid.build_document.file,
      "sheet.xlsx",
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )
    assert_not new_bid.valid?, "Quotation Token is not unique"
  end

  test "that email is unique per notice" do
    new_bid = @current_tender.bids.create name: "abc", email: @bid.email
    attach_file_to_record(
      new_bid.build_document.file,
      "sheet.xlsx",
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )

    assert_not new_bid.valid?, "Email per notice needs to be unique"
  end
end
