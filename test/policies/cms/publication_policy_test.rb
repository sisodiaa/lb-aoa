require "test_helper"

class CMS::PublicationPolicyTest < ActiveSupport::TestCase
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
    assert CMS::PublicationPolicy.new(@confirmed_board_admin, @draft_post).update?
    assert_not CMS::PublicationPolicy.new(@confirmed_board_admin, @published_post).update?
  end
end
