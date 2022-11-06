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
  end
end
