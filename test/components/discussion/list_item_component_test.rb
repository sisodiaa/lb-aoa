# frozen_string_literal: true

require "test_helper"

class Discussion::ListItemComponentTest < ViewComponent::TestCase
  test "that an individual discussion item is rendered" do
    discussion = discussions(:rickshaw)
    render_inline(Discussion::ListItemComponent.new(discussion: discussion))
    assert_selector(
      "a##{dom_id(discussion)}.block[href=\"/discussions/#{discussion.discussion_token}\"]",
      text: discussion.subject
    )
  end

  test "that lock symbol is rendered for locked discussion topics" do
    discussion = discussions(:wifi)
    render_inline(Discussion::ListItemComponent.new(discussion: discussion))
    assert_selector "svg title", text: "Locked Discussion"
  end

  test "that lock symbol is not rendered for unlocked discussion topics" do
    discussion = discussions(:rickshaw)
    render_inline(Discussion::ListItemComponent.new(discussion: discussion))
    assert_no_selector "svg title", text: "Locked Discussion"
  end

  test "that calendar with date icon is rendered along with date" do
    discussion = discussions(:rickshaw)
    render_inline(Discussion::ListItemComponent.new(discussion: discussion))
    assert_selector "svg title", text: "Posted on"
    assert_selector "a##{dom_id(discussion)} p", text: discussion.created_at.strftime("%d %b %y")
  end
end
