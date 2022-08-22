require "test_helper"

class OwnerTest < ActiveSupport::TestCase
  setup do
    @confirmed_linked_owner = owners(:confirmed_linked_owner)
  end

  teardown do
    @confirmed_linked_owner = nil
  end

  test "that ArgumentError is raised upon invalid assignment to account_status" do
    assert_raises ArgumentError do
      @confirmed_linked_owner.account_status = "banned"
    end
  end
end
