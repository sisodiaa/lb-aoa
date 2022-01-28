require "application_system_test_case"

module CMS
  class PublicationsTest < ApplicationSystemTestCase
    setup do
      Warden.test_mode!
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @draft_post = posts(:plantation)
    end

    teardown do
      @confirmed_board_admin = @draft_post = nil
      Warden.test_reset!
    end

    test "publishing a post" do
      login_as @confirmed_board_admin, scope: :admin

      visit cms_post_url(@draft_post)

      click_button "Publish Post"

      assert_selector :css, "[role='toast']", text: "Post was successfully published."

      logout :admin
    end
  end
end
