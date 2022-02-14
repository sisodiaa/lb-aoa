require "test_helper"

class SelectionTest < ActiveSupport::TestCase
  setup do
    @paani = selections(:paani)
    @mixed = selections(:mixed)
  end

  teardown do
    @paani = @mixed = nil
  end

  test "that reason is given" do
    @paani.reason = ""
    assert_not @paani.valid?, "Reason is required for selection"
  end

  test "bid belongs to tender" do
    assert_not @mixed.valid?, "Bid should belong to Tender"
  end
end
