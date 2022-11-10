require "test_helper"

class CommentTest < ActiveSupport::TestCase
  setup do
    @comment = comments(:rickshaw_comment_one)
  end

  teardown do
    @comment = nil
  end

  test "that comment's content is required" do
    @comment.content = ""
    assert_not @comment.valid?, "Content is not given"
  end
end
