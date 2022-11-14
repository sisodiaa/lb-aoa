require "test_helper"

module Front
  class CommentsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @owner_with_approved_membership = owners(:confirmed_linked_owner)
      @owner_with_under_review_membership = owners(:confirmed_linked_co_owner)
      @discussion = discussions(:rickshaw)
      @comment = comments(:rickshaw_comment_one)
      @comments_comment = comments(:rickshaw_comment_three)
    end

    teardown do
      @comments_comment = @comment = @discussion = nil
      @owner_with_approved_membership = @owner_with_under_review_membership = nil
    end

    test "that owner should be logged in to access comments" do
      get discussion_comments_path(@discussion)
      assert_redirected_to new_owner_session_path
    end

    test "that owner creates a new comment for a discussion" do
      sign_in @owner_with_approved_membership, scope: :owner

      assert_difference "Comment.count" do
        post discussion_comments_path(@discussion), params: {
          comment: {
            content: "<h1><em>Rich text</em> using HTML</h1>"
          }
        }
      end

      assert_redirected_to discussion_comment_path(@discussion, Comment.last)

      sign_out :owner
    end

    test "that owner creates a new comment for another comment" do
      sign_in @owner_with_approved_membership, scope: :owner

      assert_difference "Comment.count" do
        post comment_comments_path(@comment), params: {
          comment: {
            content: "<h1><em>Rich text</em> using HTML</h1>"
          }
        }
      end

      assert_redirected_to comment_comment_path(@comment, Comment.last)

      sign_out :owner
    end

    test "that only an owner with an approved membership can access comments" do
      sign_in @owner_with_approved_membership, scope: :owner

      get discussion_comments_path(@discussion)
      assert_response :success

      sign_out :owner
    end

    test "that an owner without any approved membership can not access comments" do
      sign_in @owner_with_under_review_membership, scope: :owner

      get discussion_comments_path(@discussion)
      assert_redirected_to root_path
      assert_equal "You cannot access comments unless you have an Approved membership.", flash[:error]

      sign_out :owner
    end

    test "that an owner without any approved membership can not access a comment" do
      sign_in @owner_with_under_review_membership, scope: :owner

      get comment_comment_path(@comment, @comments_comment)
      assert_redirected_to root_path
      assert_equal "You cannot access this comment unless you have an Approved membership.", flash[:error]

      sign_out :owner
    end

    test "that an owner without any approved membership can not create a comment" do
      sign_in @owner_with_under_review_membership, scope: :owner

      assert_difference "Comment.count", 0 do
        post comment_comments_path(@comment), params: {
          comment: {
            content: "<h1><em>Rich text</em> using HTML</h1>"
          }
        }
      end

      assert_redirected_to root_path
      assert_equal "You cannot create a comment unless you have an Approved membership.", flash[:error]

      sign_out :owner
    end
  end
end
