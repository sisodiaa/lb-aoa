require "test_helper"

class SelectionTest < ActiveSupport::TestCase
  setup do
    @paani = selections(:paani)
    @mixed = selections(:mixed)
  end

  teardown do
    @paani = @mixed = nil
  end

  test "that reason is given" do
    @paani.reason = ""
    assert_not @paani.valid?, "Reason is required for selection"
  end

  test "bid belongs to tender" do
    assert_not @mixed.valid?, "Bid should belong to Tender"
  end

  test "that tender's notice state changes upon selection" do
    @paani.destroy
    tender = tenders(:water_purifier)
    assert tender.under_review?
    assert_not tender.reviewed?

    Selection.create!(
      tender: tender,
      bid: bids(:paaniwala),
      reason: "Value for money and time with good quality"
    )

    assert_not tender.under_review?
    assert tender.reviewed?
  end
end
