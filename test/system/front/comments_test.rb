require "application_system_test_case"

module Front
  class CommentsTest < ApplicationSystemTestCase
    setup do
      Warden.test_mode!

      @owner = owners(:confirmed_linked_owner)
      @discussion = discussions(:rickshaw)
      @comment = comments(:rickshaw_comment_one)
      @comments_comment = comments(:rickshaw_comment_three)
      login_as @owner, scope: :owner
    end

    teardown do
      logout :owner
      @comments_comment = @comment = @discussion = nil
      @owner = nil
      Warden.test_reset!
    end

    test "that error is listed if comment's content for a discussion is not present" do
      visit new_discussion_comment_path(@discussion)

      within "form#new_comment" do
        click_on "Add Comment"
        assert_selector "#error_explanation li", text: "Content can't be blank"
      end
    end

    test "to add new comment to a disucssion" do
      visit new_discussion_comment_path(@discussion)

      within "form#new_comment" do
        find(:xpath, "//trix-editor").set("this is a comment")
        click_on "Add Comment"
      end

      assert_selector "div", text: "this is a comment"
      assert_selector "[role='toast']", text: "A new comment was successfully posted."
    end

    test "list all comments of a discussion" do
      visit discussion_comments_path(@discussion)

      within "div##{dom_id(@discussion, :comments)}" do
        assert_selector ".comment", count: 2
      end
    end

    test "that error is listed if comment's content for another comment is not present" do
      visit new_comment_comment_path(@comment)

      within "form#new_comment" do
        click_on "Add Comment"
        assert_selector "#error_explanation li", text: "Content can't be blank"
      end
    end

    test "to add new comment to another comment" do
      visit new_comment_comment_path(@comment)

      within "form#new_comment" do
        find(:xpath, "//trix-editor").set("this is a comment for another comment")
        click_on "Add Comment"
      end

      assert_selector "div", text: "this is a comment for another comment"
      assert_selector "[role='toast']", text: "A new comment was successfully posted."
    end

    test "list all comments of a comment" do
      visit comment_comments_path(@comment)

      within "div##{dom_id(@comment, :comments)}" do
        assert_selector ".comment", count: 1
      end
    end
  end
end
