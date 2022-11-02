require "application_system_test_case"

module Front
  class DiscussionsTest < ApplicationSystemTestCase
    setup do
      Warden.test_mode!

      @owner = owners(:confirmed_linked_owner)
      login_as @owner, scope: :owner
    end

    teardown do
      logout :owner
      @owner = nil
      Warden.test_reset!
    end

    test "that errors are listed if `subject` and/or `description` is not present" do
      visit new_discussion_path

      within "form#new_discussion" do
        click_on "Create Discussion Topic"

        assert_selector "#error_explanation li", text: "Subject can't be blank"
        assert_selector "#error_explanation li", text: "Description can't be blank"
      end
    end

    test "creation of new discussion topic" do
      visit new_discussion_path

      within "form#new_discussion" do
        fill_in "Subject", with: "New discussion topic"
        find(:xpath, "//trix-editor").set("this is the detailed description")
        click_on "Create Discussion Topic"
      end

      assert_selector "h1#discussion-subject", text: "New discussion topic"
      assert_selector "div#discussion-description", text: "this is the detailed description"
      assert_selector "[role='toast']", text: "A new discussion topic was successfully created."
    end
  end
end
