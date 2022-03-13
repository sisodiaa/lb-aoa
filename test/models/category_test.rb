require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  setup do
    @category = categories(:horticulture)
  end

  teardown do
    @category = nil
  end

  test "that name is given" do
    @category.name = ""
    assert_not @category.valid?, "Name is not present"
  end

  test "that name is not longer than 50 characters" do
    @category.name = "a" * 51
    assert_not @category.valid?, "Name is longer than 50 characters"
  end

  test "that name is saved in lowercase" do
    Category.create!(name: "Medical")

    assert_equal "medical", Category.last.name
  end
end
