require "test_helper"

class CMS::PostDocumentsPolicyTest < ActiveSupport::TestCase
  setup do
    @confirmed_board_admin = admins(:confirmed_board_admin)

    @draft_post = posts(:plantation)
    @published_post = posts(:lotus)
  end

  teardown do
    @draft_post = @published_post = nil
    @confirmed_board_admin = nil
  end

  def test_create
    assert CMS::PostDocumentsPolicy.new(@confirmed_board_admin, @draft_post).create?
    assert_not CMS::PostDocumentsPolicy.new(@confirmed_board_admin, @published_post).create?
  end

  def test_destroy
    assert CMS::PostDocumentsPolicy.new(@confirmed_board_admin, @draft_post).destroy?
    assert_not CMS::PostDocumentsPolicy.new(@confirmed_board_admin, @published_post).destroy?
  end
end
