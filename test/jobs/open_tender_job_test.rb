require "test_helper"

class OpenTenderJobTest < ActiveJob::TestCase
  setup do
    @tender = tenders(:air_quality_monitors)
  end

  teardown do
    @tender = nil
  end

  test "tender notice state changes to current" do
    assert @tender.upcoming?
    OpenTenderJob.perform_now(@tender.reference_id)
    assert @tender.reload.current?
  end
end
