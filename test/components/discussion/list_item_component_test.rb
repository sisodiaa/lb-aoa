# frozen_string_literal: true

require "test_helper"

class Discussion::ListItemComponentTest < ViewComponent::TestCase
  test "that an individual discussion item link is rendered" do
    discussion = discussions(:rickshaw)
    render_inline(Discussion::ListItemComponent.new(discussion: discussion))
    assert_selector "a##{dom_id(discussion)}.block[href=\"/discussions/#{discussion.discussion_token}\"]"
    assert_selector "div.inline-flex.gap-x-3"
  end
end
