require "application_system_test_case"

module CMS
  class PublicationsTest < ApplicationSystemTestCase
    setup do
      Warden.test_mode!
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @draft_post = posts(:plantation)

      Prosopite.pause
      @draft_post.documents.each do |document|
        attach_file_to_record document.file, "square.png", "image/png"
      end
      Prosopite.resume
    end

    teardown do
      @confirmed_board_admin = @draft_post = nil
      Warden.test_reset!
    end

    test "publishing a post" do
      login_as @confirmed_board_admin, scope: :admin

      visit cms_post_url(@draft_post)

      click_button "Publish Post"

      assert_selector "#post-toggler"
      assert_selector :css, "[role='toast']", text: "Post was successfully published."

      logout :admin
    end
  end
end
