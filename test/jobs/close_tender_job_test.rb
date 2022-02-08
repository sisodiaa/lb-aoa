require "test_helper"

class CloseTenderJobTest < ActiveJob::TestCase
  setup do
    @tender = tenders(:barb_wire)
  end

  teardown do
    @tender = nil
  end

  test "tender notice state changes to under review" do
    assert @tender.current?
    CloseTenderJob.perform_now(@tender.reference_id)
    assert @tender.reload.under_review?
  end
end
