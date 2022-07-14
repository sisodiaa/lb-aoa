require "test_helper"

class DocumentTest < ActiveSupport::TestCase
  setup do
    @image_document = documents(:image)
    @bid_document = documents(:sheet)
  end

  teardown do
    @image_document = @bid_document = nil
  end

  test "that a document without annotation is valid" do
    attach_file_to_record @image_document.file, "square.png", "image/png"
    @image_document.annotation = ""
    assert @image_document.valid?
  end

  test "that an annotation if present should not be more than 50 characters" do
    attach_file_to_record @image_document.file, "square.png", "image/png"
    @image_document.annotation = "a" * 51
    assert_not @image_document.valid?, "Annotation is longer than 50 characters"
  end

  test "that attachment without attachment is invalid" do
    assert_not @image_document.file.attached?,
      "Document should not have attachment"

    assert_not @image_document.valid?, "Document without attachment is invalid"
  end

  test "that document with attachment is valid" do
    attach_file_to_record @image_document.file, "square.png", "image/png"
    assert @image_document.valid?
  end

  test "that attachment should not be more than 20 MB in size" do
    attach_file_to_record @image_document.file, "square.png", "image/png"
    # stub the file size to 21 MB
    @image_document.file.stub(:byte_size, 21.megabytes) do
      assert_not @image_document.valid?, "Attachment size is bigger than 20 MB"
    end
  end

  test "that only pdf, images, and excel files are allowed as attachment" do
    attach_file_to_record @image_document.file, "square.png", "image/png"
    assert @image_document.valid?

    # stub the content type to jpg format
    @image_document.file.stub(:content_type, "image/jpeg") do
      assert @image_document.valid?
    end

    # stub the content type to pdf format
    @image_document.file.stub(:content_type, "application/pdf") do
      assert @image_document.valid?
    end

    # stub the content type to excel format
    @image_document.file.stub(:content_type, "application/vnd.ms-excel") do
      assert @image_document.valid?
    end

    # stub the content type to zip format
    @image_document.file.stub(:content_type, "application/zip") do
      assert_not @image_document.valid?, "Attachment should be image or pdf"
    end
  end

  test "that only excel or pdf files are allowed as attachment for Bids" do
    attach_file_to_record(
      @bid_document.file,
      "sheet.xlsx",
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )
    assert @bid_document.valid?

    attach_file_to_record(
      @bid_document.file,
      "vim-cheatsheet.pdf",
      "application/pdf"
    )
    assert @bid_document.valid?

    attach_file_to_record @bid_document.file, "square.png", "image/png"
    assert_not @bid_document.valid?, "Only excel files are allowed"
  end
end
