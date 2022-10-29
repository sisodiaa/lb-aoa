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
end
