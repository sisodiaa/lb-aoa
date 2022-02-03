require "application_system_test_case"

module TMS
  class TendersTest < ApplicationSystemTestCase
    setup do
      Warden.test_mode!
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @draft_tender = tenders(:cctv_cables)

      login_as @confirmed_board_admin, scope: :admin
    end

    teardown do
      logout :admin
      @confirmed_board_admin = @draft_tender = nil
      Warden.test_reset!
    end

    test "showing error when blank form is submitted" do
      new_tender_with_blank_form
      assert_selector "#error_explanation li", text: "Reference can't be blank"
      assert_selector "#error_explanation li", text: "Title can't be blank"
      assert_selector "#error_explanation li", text: "Description can't be blank"
      assert_selector "#error_explanation li", text: "Opens on can't be blank"
      assert_selector "#error_explanation li", text: "Closes on can't be blank"
    end

    private

    def new_tender_with_blank_form
      visit new_tms_tender_url
      click_on "Create Tender"
    end
  end
end
