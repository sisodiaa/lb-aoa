require "test_helper"

class TMS::TenderDocumentPolicyTest < ActiveSupport::TestCase
  setup do
    @confirmed_board_admin = admins(:confirmed_board_admin)

    @draft_tender = tenders(:cctv_cables)
    @published_tender = tenders(:air_quality_monitors)
  end

  teardown do
    @draft_tender = @published_tender = nil
    @confirmed_board_admin = nil
  end

  def test_create
    assert TMS::TenderDocumentPolicy.new(@confirmed_board_admin, @draft_tender).create?
    assert_not TMS::TenderDocumentPolicy.new(@confirmed_board_admin, @published_tender).create?
  end

  def test_destroy
    assert TMS::TenderDocumentPolicy.new(@confirmed_board_admin, @draft_tender).destroy?
    assert_not TMS::TenderDocumentPolicy.new(@confirmed_board_admin, @published_tender).destroy?
  end
end
