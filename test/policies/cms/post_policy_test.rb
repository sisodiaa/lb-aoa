require "test_helper"

class CMS::PostPolicyTest < ActiveSupport::TestCase
  setup do
    @confirmed_board_admin = admins(:confirmed_board_admin)

    @draft_post = posts(:plantation)
    @published_post = posts(:lotus)
  end

  teardown do
    @draft_post = @published_post = nil
    @confirmed_board_admin = nil
  end

  def test_update
    assert CMS::PostPolicy.new(@confirmed_board_admin, @draft_post).update?
    assert_not CMS::PostPolicy.new(@confirmed_board_admin, @published_post).update?
  end

  def test_destroy
    assert CMS::PostPolicy.new(@confirmed_board_admin, @draft_post).destroy?
    assert_not CMS::PostPolicy.new(@confirmed_board_admin, @published_post).destroy?
  end
end
