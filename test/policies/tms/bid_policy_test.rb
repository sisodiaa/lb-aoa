require "test_helper"

class TMS::BidPolicyTest < ActiveSupport::TestCase
  setup do
    @upcoming_tender = tenders(:air_quality_monitors)
    @current_tender = tenders(:barb_wire)
    @under_review_tender = tenders(:water_purifier)
    @reviewed_tender = tenders(:elevator_buttons)
  end

  teardown do
    @upcoming_tender = @current_tender = @under_review_tender = @reviewed_tender = nil
  end

  def test_scope
    bids = TMS::BidPolicy::Scope.new(nil, @reviewed_tender).resolve
    assert_includes bids, bids(:elevatorwala)

    bids = TMS::BidPolicy::Scope.new(nil, @under_review_tender).resolve
    assert_includes bids, bids(:waterwala)

    assert_raises(Pundit::NotAuthorizedError) do
      TMS::BidPolicy::Scope.new(nil, @upcoming_tender).resolve
    end

    assert_raises(Pundit::NotAuthorizedError) do
      TMS::BidPolicy::Scope.new(nil, @current_tender).resolve
    end
  end

  def test_show
    assert_not TMS::BidPolicy.new(nil, @upcoming_tender).show?
    assert_not TMS::BidPolicy.new(nil, @current_tender).show?
    assert TMS::BidPolicy.new(nil, @under_review_tender).show?
    assert TMS::BidPolicy.new(nil, @reviewed_tender).show?
  end

  def test_new
    assert_not TMS::BidPolicy.new(nil, @upcoming_tender).new?
    assert TMS::BidPolicy.new(nil, @current_tender).new?
    assert_not TMS::BidPolicy.new(nil, @under_review_tender).new?
    assert_not TMS::BidPolicy.new(nil, @reviewed_tender).new?
  end

  def test_create
    assert_not TMS::BidPolicy.new(nil, @upcoming_tender).create?
    assert TMS::BidPolicy.new(nil, @current_tender).create?
    assert_not TMS::BidPolicy.new(nil, @under_review_tender).create?
    assert_not TMS::BidPolicy.new(nil, @reviewed_tender).create?
  end
end
