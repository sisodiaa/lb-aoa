require "test_helper"

class PostDocumentsTest < ActionDispatch::IntegrationTest
  setup do
    @draft_post = posts(:plantation)
  end

  teardown do
    @draft_post = nil
  end

  test "that attached documents get deleted when post is deleted" do
    assert_difference("Post.count", -1) do
      assert_difference("Document.count", -2) do
        delete cms_post_url(@draft_post)
      end
    end
  end
end
