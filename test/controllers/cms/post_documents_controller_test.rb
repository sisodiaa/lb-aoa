require "test_helper"

module CMS
  class PostDocumentsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @draft_post = posts(:plantation)
      @document = documents(:image)
    end

    teardown do
      @confirmed_board_admin = @draft_post = @document = nil
    end

    test "#authenticate_admin!" do
      get cms_post_documents_path(@draft_post)
      assert_redirected_to new_admin_session_path
    end

    test "#create" do
      authorised_admin do
        assert_difference("Document.count") do
          post cms_post_documents_path(@draft_post), params: {
            document: {
              file: fixture_file_upload("portrait.png", "image/png"),
              annotation: "Portrait"
            }
          }
        end

        assert @draft_post.documents.last.file.attached?
        assert_equal ActiveStorage::Attachment.count, 1
        assert_redirected_to cms_post_documents_path(@draft_post)
      end
    end

    test "#destroy" do
      authorised_admin do
        assert_difference("Document.count", -1) do
          delete cms_post_document_path(@draft_post, @document)
        end

        assert_redirected_to cms_post_documents_path(@draft_post)
        assert_equal "Attachment was successfully removed", flash[:notice]
      end
    end

    private

    def authorised_admin
      sign_in @confirmed_board_admin, scope: :admin
      yield if block_given?
      sign_out :admin
    end
  end
end
