require "application_system_test_case"

module TMS
  class PublicationsTest < ApplicationSystemTestCase
    setup do
      Warden.test_mode!
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @draft_tender = tenders(:cctv_cables)

      @draft_tender.documents.each do |document|
        attach_file_to_record document.file, "square.png", "image/png"
      end
    end

    teardown do
      @confirmed_board_admin = @draft_tender = nil
      Warden.test_reset!
    end

    test "publishing a tender" do
      authenticated_admin do
        visit tms_tender_url(@draft_tender)
        click_button "Publish Tender"
        assert_selector "[role='toast']", text: "Tender was successfully published."
        assert_text "Tender successfully published for viewing here."
      end
    end

    test "can not publish a tender with closing date before opening date" do
      @draft_tender.opening = @draft_tender.closing + 3.days
      @draft_tender.save

      authenticated_admin do
        visit tms_tender_url(@draft_tender)
        click_button "Publish Tender"
        assert_selector "[role='toast']", text: "Tender was not published."
      end
    end

    test "can not publish a tender with opening date before current date" do
      @draft_tender.opening = DateTime.current - 3.days
      @draft_tender.save

      authenticated_admin do
        visit tms_tender_url(@draft_tender)
        click_button "Publish Tender"
        assert_selector "[role='toast']", text: "Tender was not published."
      end
    end

    test "can not publish a tender with opening date and closing date before current date" do
      @draft_tender.opening = DateTime.current - 3.days
      @draft_tender.closing = DateTime.current - 2.days
      @draft_tender.save

      authenticated_admin do
        visit tms_tender_url(@draft_tender)
        click_button "Publish Tender"
        assert_selector "[role='toast']", text: "Tender was not published."
      end
    end

    private

    def authenticated_admin
      login_as @confirmed_board_admin, scope: :admin
      yield if block_given?
      logout :admin
    end
  end
end
