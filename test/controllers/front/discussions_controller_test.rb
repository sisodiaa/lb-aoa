require "test_helper"

module Front
  class DiscussionsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @owner = owners(:confirmed_linked_owner)
    end

    teardown do
      @owner = nil
    end

    test "that owner should be logged in to access discussions" do
      get discussions_path
      assert_redirected_to new_owner_session_path
    end

    test "that owner creates a new discussion" do
      sign_in @owner, scope: :owner

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
  end
end
