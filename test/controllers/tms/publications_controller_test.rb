require "test_helper"

module TMS
  class PublicationsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @draft_tender = tenders(:cctv_cables)
    end

    teardown do
      @confirmed_board_admin = @draft_tender = nil
    end

    test "#authenticate_admin!" do
      patch publish_tms_tender_path(@draft_tender)
      assert_redirected_to new_admin_session_path
    end

    test "publish a tender" do
      sign_in @confirmed_board_admin, scope: :admin

      authenticated_admin do
        assert @draft_tender.draft?
        assert_not @draft_tender.published?
        assert_nil @draft_tender.published_at

        patch publish_tms_tender_path(@draft_tender), params: {
          tender: {
            publication_state: "published"
          }
        }

        assert_not @draft_tender.reload.draft?
        assert @draft_tender.published?
        assert_not_nil @draft_tender.published_at
      end
    end

    private

    def authenticated_admin
      sign_in @confirmed_board_admin, scope: :admin
      yield if block_given?
      sign_out :admin
    end
  end
end
