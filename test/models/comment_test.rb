require "test_helper"

class CommentTest < ActiveSupport::TestCase
  setup do
    @comment = comments(:rickshaw_comment_one)
    @discussion = discussions(:rickshaw)
  end

  teardown do
    @comment = @discussion = nil
  end

  test "that comment's content is required" do
    @comment.content = ""
    assert_not @comment.valid?, "Content is not given"
  end

  test "that a comment token is generated upon creation of a new comment" do
    comment = Comment.create(
      content: "<h1><em>Rich text</em> using HTML</h1>",
      commentable_id: @discussion.id,
      commentable_type: "Discussion",
      author: @comment.author
    )

    assert_not_nil comment.comment_token, "Comment Token was not generated"
  end

  test "that unique comment token is generated for new comments" do
    new_comment = @comment.dup
    assert_not new_comment.valid?, "Comment Token is not unique"
  end

  test "that `to_param` uses `comment_token`" do
    assert_equal @comment.to_param, @comment.comment_token, "to_param is not comment_token"
  end
end
