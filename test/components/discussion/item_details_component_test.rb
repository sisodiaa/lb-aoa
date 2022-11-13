# frozen_string_literal: true

require "test_helper"

class Discussion::ItemDetailsComponentTest < ViewComponent::TestCase
  test "that an individual discussion item is rendered" do
    discussion = discussions(:rickshaw)
    render_inline(Discussion::ItemDetailsComponent.new(discussion: discussion))
    assert_selector "div##{dom_id(discussion)}.p-4"
    assert_selector "div.inline-flex.gap-x-1"
  end
end
