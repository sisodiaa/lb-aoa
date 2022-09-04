require "test_helper"

class PropertyTest < ActiveSupport::TestCase
  setup do
    @registered_property = properties(:registered_property)
  end

  teardown do
    @registered_property = nil
  end

  test "that unique property token is generated for new property record" do
    new_property = @registered_property.dup
    assert_not new_property.valid?, "Property Token is not unique"
  end
end
