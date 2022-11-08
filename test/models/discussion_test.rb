require "test_helper"

class DiscussionTest < ActiveSupport::TestCase
  setup do
    @discussion = discussions(:rickshaw)
    @locked_discussion = discussions(:wifi)
  end

  teardown do
    @discussion = @locked_discussion = nil
  end

  test "that subject is present" do
    @discussion.subject = ""
    assert_not @discussion.valid?, "Subject is not given"
  end

  test "that subject is not longer than 256 characters" do
    @discussion.subject = "a" * 257
    assert_not @discussion.valid?, "Subject is longer than 256 characters"
  end

  test "that description is present" do
    @discussion.description = ""
    assert_not @discussion.valid?, "Description is not given"
  end

  test "that `lock` event transitions `accessibility_state` from `unlocked` to `locked`" do
    assert @discussion.unlocked?
    assert_not @discussion.locked?

    @discussion.lock

    assert_not @discussion.unlocked?
    assert @discussion.locked?
  end

  test "that `unlock` event transitions `accessibility_state` from `locked` to `unlocked`" do
    assert @locked_discussion.locked?
    assert_not @locked_discussion.unlocked?

    @locked_discussion.unlock

    assert_not @locked_discussion.locked?
    assert @locked_discussion.unlocked?
  end

  test "that a discussion token is generate upon creation of a new discussion" do
    discussion = Discussion.create(
      subject: "a new discussion thread",
      description: "<h1><em>Rich text</em> using HTML</h1>",
      author: @discussion.author
    )

    assert_not_nil discussion.discussion_token, "Discussion Token was not generated"
  end

  test "that unique discussion token is generated for new discussions" do
    new_discussion = @discussion.dup
    assert_not new_discussion.valid?, "Discussion Token is not unique"
    assert_equal @discussion.to_param, @discussion.discussion_token
  end

  test "that `to_param` uses `discussion_token`" do
    assert_equal @discussion.to_param, @discussion.discussion_token, "to_param is not discussion_token"
  end

  test "#toggle_accessibility" do
    assert @discussion.unlocked?
    assert_not @discussion.locked?
    @discussion.toggle_accessibility
    assert @discussion.locked?
    assert_not @discussion.unlocked?

    assert @locked_discussion.locked?
    assert_not @locked_discussion.unlocked?
    @locked_discussion.toggle_accessibility
    assert @locked_discussion.unlocked?
    assert_not @locked_discussion.locked?
  end
end
