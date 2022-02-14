require "test_helper"

class TMS::SelectionPolicyTest < ActiveSupport::TestCase
  setup do
    @confirmed_board_admin = admins(:confirmed_board_admin)
    @upcoming_tender = tenders(:air_quality_monitors)
    @current_tender = tenders(:barb_wire)
    @under_review_tender = tenders(:water_purifier)
    @reviewed_tender = tenders(:elevator_buttons)
  end

  teardown do
    @upcoming_tender = @current_tender = @under_review_tender = @reviewed_tender = nil
    @confirmed_board_admin = nil
  end

  def test_new
    assert_not TMS::SelectionPolicy.new(@confirmed_board_admin, @upcoming_tender).new?
    assert_not TMS::SelectionPolicy.new(@confirmed_board_admin, @current_tender).new?
    assert TMS::SelectionPolicy.new(@confirmed_board_admin, @under_review_tender).new?
    assert_not TMS::SelectionPolicy.new(@confirmed_board_admin, @reviewed_tender).new?
  end

  def test_create
    assert_not TMS::SelectionPolicy.new(@confirmed_board_admin, @upcoming_tender).create?
    assert_not TMS::SelectionPolicy.new(@confirmed_board_admin, @current_tender).create?
    assert TMS::SelectionPolicy.new(@confirmed_board_admin, @under_review_tender).create?
    assert_not TMS::SelectionPolicy.new(@confirmed_board_admin, @reviewed_tender).create?
  end
end
