require "application_system_test_case"

module Front
  class CommentsTest < ApplicationSystemTestCase
    setup do
      Warden.test_mode!

      @owner = owners(:confirmed_linked_owner)
      @discussion = discussions(:rickshaw)
      @comment = comments(:rickshaw_comment_one)
      @comments_comment = comments(:rickshaw_comment_three)
      @comment_with_comments = comments(:rickshaw_comment_two)
      login_as @owner, scope: :owner
    end

    teardown do
      logout :owner
      @comment_with_comments = @comments_comment = @comment = @discussion = nil
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

    test "SP - that error is listed if comment's content for a discussion is not present" do
      visit discussion_path(@discussion)

      assert_selector "turbo-frame##{dom_id(@discussion, :comment_form)}", visible: false

      within "div##{dom_id(@discussion)}" do
        click_on "Add Comment"
      end

      within "turbo-frame##{dom_id(@discussion, :comment_form)} form#new_comment" do
        click_on "Add Comment"
        assert_selector "#error_explanation li", text: "Content can't be blank"
      end
    end

    test "to add new comment to a discussion" do
      visit new_discussion_comment_path(@discussion)

      within "form#new_comment" do
        find(:xpath, "//trix-editor").set("this is a comment")
        click_on "Add Comment"
      end

      assert_selector "div", text: "this is a comment"
      assert_selector "[role='toast']", text: "A new comment was successfully posted."
    end

    test "SP - to add new comment to a discussion" do
      visit discussion_path(@discussion)

      within "turbo-frame##{dom_id(@discussion, :comments)}" do
        assert_selector ".comment", count: 2
      end

      within "#comments-total" do
        assert_selector "div", text: "3 comments"
      end

      within "div##{dom_id(@discussion)}" do
        click_on "Add Comment"
      end

      within "turbo-frame##{dom_id(@discussion, :comment_form)} form#new_comment" do
        find(:xpath, "//trix-editor").set("this is a comment")
        click_on "Add Comment"
      end

      within "turbo-frame##{dom_id(@discussion, :comments)}" do
        assert_selector ".comment", count: 3

        within ".comment:last-child" do
          assert_selector "div", text: "this is a comment"
        end
      end

      within "#comments-total" do
        assert_selector "div", text: "4 comments"
      end

      assert_selector "[role='toast']", text: "A new comment was successfully posted."
    end

    test "that error is listed if comment's content for another comment is not present" do
      visit new_comment_comment_path(@comment)

      within "form#new_comment" do
        click_on "Add Comment"
        assert_selector "#error_explanation li", text: "Content can't be blank"
      end
    end

    test "SP - that error is listed if comment's content for another comment is not present" do
      visit comment_comment_path(@comment, @comments_comment)

      assert_selector "turbo-frame##{dom_id(@comments_comment, :comment_form)}", visible: false

      within "div##{dom_id(@comments_comment)}" do
        click_on "Add Comment"
      end

      within "turbo-frame##{dom_id(@comments_comment, :comment_form)} form#new_comment" do
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

    test "SP - to add new comment to another comment" do
      visit comment_comment_path(@comment, @comments_comment)

      assert_selector "turbo-frame##{dom_id(@comments_comment, :comment_form)}", visible: false
      assert_selector "turbo-frame##{dom_id(@comments_comment, :comments)}", visible: false
      assert_selector "#comments-total", visible: false

      within "div##{dom_id(@comments_comment)}" do
        click_on "Add Comment"
      end

      within "turbo-frame##{dom_id(@comments_comment, :comment_form)} form#new_comment" do
        find(:xpath, "//trix-editor").set("this is a comment for another comment")
        click_on "Add Comment"
      end

      within "turbo-frame##{dom_id(@comments_comment, :comments)}" do
        assert_selector ".comment", count: 1

        within ".comment:last-child" do
          assert_selector "div", text: "this is a comment for another comment"
        end
      end

      within "#comments-total" do
        assert_selector "div", text: "1 comment"
      end

      assert_selector "[role='toast']", text: "A new comment was successfully posted."
    end

    test "list all comments of a comment" do
      visit comment_comments_path(@comment)

      within "turbo-frame##{dom_id(@comment, :comments)}" do
        assert_selector ".comment", count: 1
      end
    end

    test "SP - list all comments of a comment" do
      visit discussion_comment_path(@discussion, @comment)

      within "turbo-frame##{dom_id(@comment, :comments)}" do
        assert_selector ".comment", count: 1
      end
    end

    test "link of back button for a discussion's comment" do
      visit discussion_comment_path(@discussion, @comment)
      assert_selector "a[href=\"/discussions/#{@discussion.to_param}\"]", text: "Back to thread"
    end

    test "link of back button for a comment's comment" do
      visit comment_comment_path(@comment, @comments_comment)
      assert_selector(
        "a[href=\"/discussions/#{@discussion.to_param}/comments/#{@comment.to_param}\"]",
        text: "Back to thread"
      )
    end

    test "that form is rendered if 'view' is set to 'form'" do
      visit comment_comment_path(@comment, @comments_comment, view: :form)

      assert_selector "form#new_comment"
    end

    test "that form is not rendered if 'view' is not set" do
      visit comment_comment_path(@comment, @comments_comment)

      assert_no_selector "form#new_comment"
    end

    test "multiple comments" do
      visit comment_comments_path(@comment_with_comments)

      within "turbo-frame##{dom_id(@comment_with_comments, :comments)}" do
        assert_selector ".comment", count: 10
        assert_selector "#comments-placeholder a", text: "Load More Comments"
        click_on "Load More Comments"

        assert_selector ".comment", count: 20
        assert_selector "#comments-placeholder a", text: "Load More Comments"
        click_on "Load More Comments"

        assert_selector ".comment", count: 25
        assert_no_selector "#comments-placeholder a"
      end
    end
  end
end
