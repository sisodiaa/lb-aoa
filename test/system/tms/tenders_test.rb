require "application_system_test_case"

module TMS
  class TendersTest < ApplicationSystemTestCase
    setup do
      Warden.test_mode!
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @draft_tender = tenders(:cctv_cables)
      @published_tender = tenders(:air_quality_monitors)

      login_as @confirmed_board_admin, scope: :admin
    end

    teardown do
      logout :admin
      @confirmed_board_admin = @draft_tender = @published_tender = nil
      Warden.test_reset!
    end

    test "show all tenders" do
      visit tms_tenders_path

      within("#_tenders") do
        assert_selector ".tender", count: 5
        click_on "Next"

        assert_selector ".tender", count: 1
      end
    end

    test "showing error when blank form is submitted" do
      new_tender_with_blank_form
      assert_selector "#error_explanation li", text: "Reference can't be blank"
      assert_selector "#error_explanation li", text: "Title can't be blank"
      assert_selector "#error_explanation li", text: "Description can't be blank"
      assert_selector "#error_explanation li", text: "Opens on can't be blank"
      assert_selector "#error_explanation li", text: "Closes on can't be blank"
    end

    test "creating a Tender" do
      create_new_tender
      assert_selector "[role='toast']", text: "Tender was successfully created."
    end

    test "updating a post" do
      edit_tender
      assert_selector "[role='toast']", text: "Tender was successfully updated."
      assert_selector "h1", text: "Edited title for system test"
    end

    test "destroying a Tender" do
      visit tms_tenders_url

      within("#_tenders") do
        assert_selector ".tender", count: 5
        assert_selector "p", text: "1 to 5 of 6 tenders"
      end

      page.accept_confirm do
        click_on "Delete", match: :first
      end

      assert_selector :css, "[role='toast']", text: "Tender was successfully destroyed."

      within("#_tenders") do
        assert_selector ".tender", count: 5
        assert_selector "p", text: "1 to 5 of 5 tenders"
      end
    end

    test "do not show Edit button for published tenders" do
      visit tms_tender_url(@published_tender)
      within("#tender-buttons-section") do
        assert_no_selector "a", text: "Edit"
      end
    end

    private

    def new_tender_with_blank_form
      visit new_tms_tender_url
      click_on "Create Tender"
    end

    def create_new_tender
      visit new_tms_tender_url
      fill_in "tender_reference_token", with: "lb/2022/jan-15/clamp"
      fill_in "Title", with: "Clamps for Vechicles"
      description = "We need clamps for our society"
      find(:xpath, "//trix-editor[@id='tender__description']").set(description)
      fill_in "tender_opens_on", with: DateTime.now + 2.days
      fill_in "tender_closes_on", with: DateTime.now + 5.days

      click_on "Create Tender"
    end

    def edit_tender
      visit edit_tms_tender_url(@draft_tender)

      fill_in "tender_title", with: "Edited title for system test"
      click_on "Update Tender"
    end
  end
end
