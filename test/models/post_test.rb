require "test_helper"

class PostTest < ActiveSupport::TestCase
  setup do
    @draft_post = posts(:plantation)
    @published_post = posts(:lotus)
    @public_post = posts(:nursery)
  end

  teardown do
    @draft_post = @published_post = @public_post = nil
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
    assert_not @draft_post.published?

    @draft_post.publish

    assert_not @draft_post.draft?
    assert @draft_post.published?
  end

  test "that publish event raises error when post is in published state" do
    assert_raise(AASM::InvalidTransition) { @published_post.publish }
  end

  test "that manual assignment of status will raise error" do
    assert_raise(AASM::NoDirectAssignmentError) do
      @published_post.publication_state = :draft
    end
  end

  test "that `declassify` event changes the visibility of a published post" do
    assert @published_post.members?
    assert_not @published_post.visitors?

    @published_post.declassify

    assert_not @published_post.members?
    assert @published_post.visitors?
  end

  test "that `classify` event changes the visibility of a public post" do
    assert @public_post.visitors?
    assert_not @public_post.members?

    @public_post.classify

    assert_not @public_post.visitors?
    assert @public_post.members?
  end

  test "that `declassify` event on a draft post raises InvalidTransition error" do
    assert_raise(AASM::InvalidTransition) { @draft_post.declassify }
  end

  test "that `declassify` event raises error when post is visible to visitors" do
    assert_raise(AASM::InvalidTransition) { @public_post.declassify }
  end

  test "that `classify` event on a draft post raises InvalidTransition error" do
    assert_raise(AASM::InvalidTransition) { @draft_post.classify }
  end

  test "that `classify` event raises error when post is visible to members" do
    assert_raise(AASM::InvalidTransition) { @published_post.classify }
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
    @draft_post.tags_list = "one, two, three, four, five, six"
    assert_not @draft_post.valid?, "Post can not be more than 5 tags"
    assert_equal ["should not have more than 5 tags"], @draft_post.errors[:tags_list]
  end

  test "#toggle_visibility" do
    assert @public_post.visitors?
    assert_not @public_post.members?

    @public_post.toggle_visibility

    assert_not @public_post.visitors?
    assert @public_post.members?

    @public_post.toggle_visibility

    assert @public_post.visitors?
    assert_not @public_post.members?
  end
end
