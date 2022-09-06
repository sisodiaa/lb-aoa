require "test_helper"

class OwnerTest < ActiveSupport::TestCase
  setup do
    @confirmed_linked_owner = owners(:confirmed_linked_owner)
    @unlinked_owner = owners(:confirmed_unlinked_owner)
  end

  teardown do
    @confirmed_linked_owner = @unlinked_owner = nil
  end

  test "that manual assignment of account status will raise error" do
    assert_raises AASM::NoDirectAssignmentError do
      @confirmed_linked_owner.account_status = "banned"
    end
  end

  test "that `link` event changes the account status" do
    assert @unlinked_owner.unlinked?
    assert_not @unlinked_owner.linked?

    @unlinked_owner.link

    assert_not @unlinked_owner.unlinked?
    assert @unlinked_owner.linked?
  end

  test "that `link` event raises error when account is already linked" do
    assert_raise(AASM::InvalidTransition) { @confirmed_linked_owner.link }
  end
end
