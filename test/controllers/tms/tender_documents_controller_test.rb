require "test_helper"

module TMS
  class TenderDocumentsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @draft_tender = tenders(:cctv_cables)
      @document = documents(:xls)
    end

    teardown do
      @confirmed_board_admin = @draft_tender = @document = nil
    end

    test "#authenticate_admin!" do
      get tms_tender_documents_path(@draft_tender)
      assert_redirected_to new_admin_session_path
    end

    test "#create" do
      authenticated_admin do
        assert_difference("Document.count") do
          post tms_tender_documents_path(@draft_tender), params: {
            document: {
              file: fixture_file_upload(
                "tender_notice.xlsx",
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
              ),
              annotation: "Tender Notice"
            }
          }
        end

        assert @draft_tender.documents.last.file.attached?
        assert_equal ActiveStorage::Attachment.count, 1
        assert_redirected_to tms_tender_documents_path(@draft_tender)
      end
    end

    test "#destroy" do
      authenticated_admin do
        assert_difference("Document.count", -1) do
          delete tms_tender_document_path(@draft_tender, @document)
        end

        assert_redirected_to tms_tender_documents_path(@draft_tender)
        assert_equal "Attachment was successfully removed", flash[:notice]
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
