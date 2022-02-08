require "test_helper"

module TMS
  class TenderPublicationFlowTest < ActionDispatch::IntegrationTest
    setup do
      Warden.test_mode!
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @draft_tender = tenders(:cctv_cables)
    end

    teardown do
      @confirmed_board_admin = @draft_tender = nil
      Warden.test_reset!
    end

    test "ensure that background jobs are scheduled upon publishing tender notice" do
      sign_in @confirmed_board_admin, scope: :admin

      assert_enqueued_jobs 1, queue: :default do
        patch publish_tms_tender_path(@draft_tender), params: {
          tender: {
            publication_state: "published"
          }
        }
      end

      assert_enqueued_with(
        job: OpenTenderJob,
        args: [@draft_tender.reference_id],
        at: @draft_tender.opening,
        queue: "default"
      ) do
        OpenTenderJob
          .set(wait_until: @draft_tender.opening)
          .perform_later(@draft_tender.reference_id)
      end

      perform_enqueued_jobs only: OpenTenderJob
      assert_performed_jobs 2, only: OpenTenderJob

      assert_performed_with(
        job: OpenTenderJob,
        args: [@draft_tender.reference_id],
        at: @draft_tender.opening,
        queue: "default"
      )

      assert_enqueued_with(
        job: CloseTenderJob,
        args: [@draft_tender.reference_id],
        at: @draft_tender.closing.to_time,
        queue: "default"
      ) do
        CloseTenderJob
          .set(wait_until: @draft_tender.closing)
          .perform_later(@draft_tender.reference_id)
      end

      perform_enqueued_jobs only: CloseTenderJob
      assert_performed_jobs 2, only: CloseTenderJob

      assert_performed_with(
        job: CloseTenderJob,
        args: [@draft_tender.reference_id],
        at: @draft_tender.closing,
        queue: "default"
      )

      sign_out :admin
    end
  end
end
