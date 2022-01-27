require "test_helper"

class PostDocumentsTest < ActionDispatch::IntegrationTest
  setup do
    @confirmed_board_admin = admins(:confirmed_board_admin)
    @draft_post = posts(:plantation)
  end

  teardown do
    @confirmed_board_admin = @draft_post = nil
  end

  test "that attached documents get deleted when post is deleted" do
    sign_in @confirmed_board_admin, scope: :admin

    assert_difference("Post.count", -1) do
      assert_difference("Document.count", -2) do
        delete cms_post_url(@draft_post)
      end
    end

    sign_out :admin
  end
end
