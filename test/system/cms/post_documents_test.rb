require "application_system_test_case"

module CMS
  class PostDocumentsTest < ApplicationSystemTestCase
    setup do
      Warden.test_mode!
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @draft_post = posts(:plantation)
      @published_post = posts(:club_chiller)

      @draft_post.documents.each do |document|
        attach_file_to_record document.file, "square.png", "image/png"
      end

      @published_post.documents.each do |document|
        attach_file_to_record document.file, "square.png", "image/png"
      end

      login_as @confirmed_board_admin, scope: :admin
    end

    teardown do
      logout :admin
      @confirmed_board_admin = @draft_post = nil
      Warden.test_reset!
    end

    test "index page show form and list of attached documents" do
      visit_post
      assert_selector "form"
      assert_selector "li.post-document", count: 2
    end

    test "attach a new file" do
      visit_post
      attach_document
      assert_file_is_attached_and_form_is_reset
    end

    test "show error if form is submitted without any attachment" do
      create_new_post_without_attachment
      assert_selector "#error_explanation li", text: "File is not choosed"
    end

    test "remove an attachment" do
      delete_first_attachment
      assert_selector "li.post-document", count: 1
      assert_text "Attachment was successfully removed"
    end

    test "Remove button and form are not shown for published post" do
      visit cms_post_documents_path(@published_post)

      assert_no_selector "form"
      assert_no_selector "a", text: "Remove"
    end

    private

    def visit_post
      visit cms_post_url(@draft_post)
      click_on "Add attachment"
    end

    def attach_document
      fill_in "document_annotation", with: "Cheatsheet for vim"
      attach_file "document_file",
        Rails.root.join("test", "fixtures", "files", "vim-cheatsheet.pdf"),
        visible: false
      click_on "Upload Document"
    end

    def assert_file_is_attached_and_form_is_reset
      assert_selector "li.post-document", count: 3
      assert_selector "li.post-document:last-child", text: "vim-cheatsheet.pdf"
      assert_text "File was successfully attached"
      assert_selector "#document_annotation", text: ""
      assert_equal "", find("#document_file").value
    end

    def create_new_post_without_attachment
      visit cms_post_url(@draft_post)
      click_on "Add attachment"
      click_on "Upload Document"
    end

    def delete_first_attachment
      visit cms_post_documents_path(@draft_post)

      page.accept_confirm do
        click_on "Remove", match: :first
      end
    end
  end
end
