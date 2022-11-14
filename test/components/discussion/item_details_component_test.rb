# frozen_string_literal: true

require "test_helper"

class Discussion::ItemDetailsComponentTest < ViewComponent::TestCase
  test "that an individual discussion item is rendered" do
    discussion = discussions(:rickshaw)
    render_inline(Discussion::ItemDetailsComponent.new(discussion: discussion, view: :show))
    assert_selector "div##{dom_id(discussion)}"
    assert_selector "div.inline-flex.gap-x-1"
  end

  test "that actions div is not rendered when view is not show" do
    discussion = discussions(:rickshaw)
    render_inline(Discussion::ItemDetailsComponent.new(discussion: discussion, view: :new))
    assert_selector "div##{dom_id(discussion)}"
    assert_no_selector "div.inline-flex.gap-x-1"
  end
end
