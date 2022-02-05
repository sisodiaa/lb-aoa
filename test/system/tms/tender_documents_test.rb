require "application_system_test_case"

module TMS
  class TenderDocumentsTest < ApplicationSystemTestCase
    setup do
      Warden.test_mode!
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @draft_tender = tenders(:cctv_cables)
      @document = documents(:xls)

      @draft_tender.documents.each do |document|
        attach_file_to_record document.file, "square.png", "image/png"
      end

      login_as @confirmed_board_admin, scope: :admin
    end

    teardown do
      logout :admin
      @confirmed_board_admin = @draft_tender = @document = nil
      Warden.test_reset!
    end

    test "index page show form and list of attached documents" do
      visit_tender_documents
      assert_selector "form"
      assert_selector "li.tender-document", count: 1
    end

    test "attach a new file" do
      visit_tender_documents
      attach_document
      assert_file_is_attached_and_form_is_reset
    end

    test "show error if form is submitted without any attachment" do
      create_new_tender_without_attachment
      assert_selector "#error_explanation li", text: "File is not choosed"
    end

    test "remove an attachment" do
      delete_first_attachment
      assert_selector "li.tender-document", count: 0
      assert_text "Attachment was successfully removed"
    end

    private

    def visit_tender_documents
      visit tms_tender_documents_path(@draft_tender)
    end

    def attach_document
      fill_in "document_annotation", with: "Cheatsheet for vim"
      attach_file "document_file",
        Rails.root.join("test", "fixtures", "files", "vim-cheatsheet.pdf"),
        visible: false
      click_on "Upload Document"
    end

    def assert_file_is_attached_and_form_is_reset
      assert_selector "li.tender-document", count: 2
      assert_selector "li.tender-document:last-child", text: "vim-cheatsheet.pdf"
      assert_text "File was successfully attached"
      assert_selector "#document_annotation", text: ""
      assert_equal "", find("#document_file").value
    end

    def create_new_tender_without_attachment
      visit tms_tender_documents_path(@draft_tender)
      click_on "Upload Document"
    end

    def delete_first_attachment
      visit tms_tender_documents_path(@draft_tender)

      page.accept_confirm do
        click_on "Remove", match: :first
      end
    end
  end
end
