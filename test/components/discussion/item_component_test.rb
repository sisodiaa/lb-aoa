# frozen_string_literal: true

require "test_helper"

class Discussion::ItemComponentTest < ViewComponent::TestCase
  test "that an individual discussion item details are rendered" do
    discussion = discussions(:rickshaw)
    render_inline(Discussion::ItemComponent.new(discussion: discussion))
    assert_selector "div##{dom_id(discussion)}"
    assert_selector "h1##{dom_id(discussion, :subject)}", text: discussion.subject
    assert_selector "div##{dom_id(discussion, :description)}"
    assert_selector "div##{dom_id(discussion, :actions)}"
  end
  test "that actions are not rendered when view is not show" do
    discussion = discussions(:rickshaw)
    render_inline(Discussion::ItemComponent.new(discussion: discussion, view: :new))
    assert_selector "div##{dom_id(discussion)}"
    assert_selector "h1##{dom_id(discussion, :subject)}", text: discussion.subject
    assert_selector "div##{dom_id(discussion, :description)}"
    assert_no_selector "div##{dom_id(discussion, :actions)}"
  end
end
