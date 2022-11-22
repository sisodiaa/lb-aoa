require "application_system_test_case"

module Front
  class DiscussionsTest < ApplicationSystemTestCase
    setup do
      Warden.test_mode!

      @owner = owners(:confirmed_linked_owner)
      @discussion = discussions(:rickshaw)
      login_as @owner, scope: :owner
    end

    teardown do
      logout :owner
      @discussion = nil
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

      assert_selector ".discussion", count: 6
    end

    test "that discussion page has subject, date and author name" do
      discussion = discussions(:rickshaw)
      visit discussion_path(discussion)

      within("div##{dom_id(discussion)}") do
        assert_selector "div", text: discussion.created_at.strftime("%d %b %Y")
        assert_selector "div", text: "Second Dummy Owner"
        assert_selector "h1", text: discussion.subject
      end

      click_on "Go back to Discussions"

      assert_selector "#discussions-list"
    end

    test "list all comments of a discussion" do
      visit discussion_comments_path(@discussion)

      within "turbo-frame##{dom_id(@discussion, :comments)}" do
        assert_selector ".comment", count: 2
      end
    end

    test "SP - that comments are listed below the discussion" do
      visit discussion_path(@discussion)

      within "turbo-frame##{dom_id(@discussion, :comments)}" do
        assert_selector ".comment", count: 2
      end
    end
  end
end
