require "test_helper"

class Front::BidPolicyTest < ActiveSupport::TestCase
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
    bids = Front::BidPolicy::Scope.new(nil, @reviewed_tender).resolve
    assert_includes bids, bids(:elevatorwala)

    bids = Front::BidPolicy::Scope.new(nil, @under_review_tender).resolve
    assert_includes bids, bids(:waterwala)

    assert_raises(Pundit::NotAuthorizedError) do
      Front::BidPolicy::Scope.new(nil, @upcoming_tender).resolve
    end

    assert_raises(Pundit::NotAuthorizedError) do
      Front::BidPolicy::Scope.new(nil, @current_tender).resolve
    end
  end

  def test_show
    assert_not Front::BidPolicy.new(nil, @upcoming_tender).show?
    assert_not Front::BidPolicy.new(nil, @current_tender).show?
    assert Front::BidPolicy.new(nil, @under_review_tender).show?
    assert Front::BidPolicy.new(nil, @reviewed_tender).show?
  end
end
