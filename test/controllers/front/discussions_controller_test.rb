require "test_helper"

module Front
  class DiscussionsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @owner_with_approved_membership = owners(:confirmed_linked_owner)
      @owner_with_under_review_membership = owners(:confirmed_linked_co_owner)
    end

    teardown do
      @owner_with_approved_membership = @owner_with_under_review_membership = nil
    end

    test "that owner should be logged in to access discussions" do
      get discussions_path
      assert_redirected_to new_owner_session_path
    end

    test "that owner creates a new discussion" do
      sign_in @owner_with_approved_membership, scope: :owner

      assert_difference "Discussion.count" do
        post discussions_path, params: {
          discussion: {
            subject: "a new discussion thread",
            description: "<h1><em>Rich text</em> using HTML</h1>"
          }
        }
      end

      assert_redirected_to discussion_path(Discussion.last)

      sign_out :owner
    end

    test "owner with an approved membership can access discussions" do
      sign_in @owner_with_approved_membership, scope: :owner

      get discussions_path
      assert_response :success

      sign_out :owner
    end

    test "owner without any approved membership can not access discussions" do
      sign_in @owner_with_under_review_membership, scope: :owner

      get discussions_path
      assert_redirected_to root_path
      assert_equal "You cannot access discussions unless you have an Approved membership.", flash[:error]

      sign_out :owner
    end

    test "owner without any approved membership can not access a discussion" do
      sign_in @owner_with_under_review_membership, scope: :owner

      get discussion_path(discussions(:rickshaw))
      assert_redirected_to root_path
      assert_equal "You cannot access this discussion unless you have an Approved membership.", flash[:error]

      sign_out :owner
    end

    test "owner without any approved membership can not create a discussion" do
      sign_in @owner_with_under_review_membership, scope: :owner

      post discussions_path, params: {
        discussion: {
          subject: "a new discussion thread",
          description: "<h1><em>Rich text</em> using HTML</h1>"
        }
      }
      assert_redirected_to root_path
      assert_equal "You cannot create discussion unless you have an Approved membership.", flash[:error]

      sign_out :owner
    end
  end
end
