require "test_helper"

class PostTest < ActiveSupport::TestCase
  setup do
    @draft_post = posts(:plantation)
    @finished_post = posts(:lotus)
    @public_post = posts(:nursery)
  end

  teardown do
    @draft_post = @finished_post = @public_post = nil
  end

  test "that title is present" do
    @draft_post.title = ""
    assert_not @draft_post.valid?, "Title of the post is necessary"
  end

  test "that title is not longer than 256 words" do
    @draft_post.title = "a" * 257
    assert_not @draft_post.valid?, "Title is longer than 256 words"
  end

  test "that publish event changes the publication_state" do
    assert @draft_post.draft?
    assert_not @draft_post.finished?

    @draft_post.publish

    assert_not @draft_post.draft?
    assert @draft_post.finished?
  end

  test "that publish event raises error when post is in finished state" do
    assert_raise(AASM::InvalidTransition) { @finished_post.publish }
  end

  test "that manual assignment of status will raise error" do
    assert_raise(AASM::NoDirectAssignmentError) do
      @finished_post.publication_state = :draft
    end
  end

  test "that broadcast event changes the visibility of a finished post" do
    assert @finished_post.members?
    assert_not @finished_post.visitors?

    @finished_post.broadcast

    assert_not @finished_post.members?
    assert @finished_post.visitors?
  end

  test "that narrowcast event changes the visibility of a public post" do
    assert @public_post.visitors?
    assert_not @public_post.members?

    @public_post.narrowcast

    assert_not @public_post.visitors?
    assert @public_post.members?
  end

  test "that broadcast event on a draft post raises InvalidTransition error" do
    assert_raise(AASM::InvalidTransition) { @draft_post.broadcast }
  end

  test "that broadcast event raises error when post is visible to visitors" do
    assert_raise(AASM::InvalidTransition) { @public_post.broadcast }
  end

  test "that narrowcast event on a draft post raises InvalidTransition error" do
    assert_raise(AASM::InvalidTransition) { @draft_post.narrowcast }
  end

  test "that narrowcast event raises error when post is visible to members" do
    assert_raise(AASM::InvalidTransition) { @finished_post.narrowcast }
  end

  test "that manual assignment of visibility_state will raise error" do
    assert_raise(AASM::NoDirectAssignmentError) do
      @public_post.visibility_state = :members
    end
  end

  test "that content is present" do
    @draft_post.content = ""
    assert_not @draft_post.valid?, "Content is missing"
  end

  test "that a post can not have more than 5 tags" do
    skip
    @draft_post.tag_list = "one, two, three, four, five, six"
    assert_not @draft_post.valid?, "Post can not be more than 5 tags"
    assert_equal ["should not be more than 5"], @draft_post.errors[:tags]
  end
end
