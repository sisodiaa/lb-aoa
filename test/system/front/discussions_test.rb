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

      assert_selector "h1", text: "New discussion topic"
      assert_selector "div", text: "this is the detailed description"
      assert_selector "[role='toast']", text: "A new discussion topic was successfully created."
    end

    test "listing of discussions" do
      visit discussions_path

      assert_selector ".discussion", count: 5
    end

    test "that discussion page has subject, date and author name" do
      discussion = discussions(:rickshaw)
      visit discussion_path(discussion)

      within("div##{dom_id(discussion)}") do
        assert_selector "p", text: discussion.created_at.strftime("%d %b %Y")
        assert_selector "p", text: "Submitted by Second Dummy Owner"
        assert_selector "h1", text: discussion.subject
      end

      click_on "Go back to Discussions"

      assert_selector "#discussions-list"
    end
  end
end
