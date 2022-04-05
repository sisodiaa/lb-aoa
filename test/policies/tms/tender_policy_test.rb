require "test_helper"

class TMS::TenderPolicyTest < ActiveSupport::TestCase
  setup do
    @confirmed_board_admin = admins(:confirmed_board_admin)

    @draft_tender = tenders(:cctv_cables)
    @published_tender = tenders(:air_quality_monitors)
  end

  teardown do
    @draft_tender = @published_tender = nil
    @confirmed_board_admin = nil
  end

  def test_edit
    assert TMS::TenderPolicy.new(@confirmed_board_admin, @draft_tender).edit?
    assert_not TMS::TenderPolicy.new(@confirmed_board_admin, @published_tender).edit?
  end

  def test_update
    assert TMS::TenderPolicy.new(@confirmed_board_admin, @draft_tender).update?
    assert_not TMS::TenderPolicy.new(@confirmed_board_admin, @published_tender).update?
  end

  def test_destroy
    assert TMS::TenderPolicy.new(@confirmed_board_admin, @draft_tender).destroy?
    assert_not TMS::TenderPolicy.new(@confirmed_board_admin, @published_tender).destroy?
  end
end
