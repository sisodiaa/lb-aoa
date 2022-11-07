require "application_system_test_case"

module Management
  class DiscussionsTest < ApplicationSystemTestCase
    setup do
      Warden.test_mode!
      @confirmed_board_admin = admins(:confirmed_board_admin)
      login_as @confirmed_board_admin, scope: :admin
    end

    teardown do
      logout :admin
      @confirmed_board_admin = nil
      Warden.test_reset!
    end

    test "that sidebar toggle works for Discussions" do
      visit management_discussions_path

      within "aside" do
        assert_selector "li", text: "Discussions", visible: false

        find("#forum-details").click

        assert_selector "li", text: "Discussions", visible: true
      end
    end

    test "lock a post" do
      visit management_discussions_path

      discussion = discussions(:rickshaw)
      puts dom_id(discussion, :accessibility)

      within "turbo-frame##{dom_id(discussion, :accessibility)}" do
        within "form##{dom_id(discussion, :form)}" do
          assert_no_selector "input##{dom_id(discussion, :accessibility_state)}[value='unlocked'][checked='checked']"
          find("label[for=\"#{dom_id(discussion, :accessibility_state)}\"]").click
          assert_selector "input##{dom_id(discussion, :accessibility_state)}[value='unlocked'][checked='checked']"
        end
      end

      assert_selector :css, "[role='toast']", text: "Accessibility state was successfully modified."
    end

    test "unlock a post" do
      visit management_discussions_path

      discussion = discussions(:wifi)

      within "turbo-frame##{dom_id(discussion, :accessibility)}" do
        within "form##{dom_id(discussion, :form)}" do
          assert_selector "input##{dom_id(discussion, :accessibility_state)}[value='unlocked'][checked='checked']"
          find("label[for=\"#{dom_id(discussion, :accessibility_state)}\"]").click
          assert_no_selector "input##{dom_id(discussion, :accessibility_state)}[value='unlocked'][checked='checked']"
        end
      end

      assert_selector :css, "[role='toast']", text: "Accessibility state was successfully modified."
    end
  end
end
