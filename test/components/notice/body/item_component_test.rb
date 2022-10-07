# frozen_string_literal: true

require "test_helper"

class Notice::Body::ItemComponentTest < ViewComponent::TestCase
  test "that component renders a list item" do
    render_inline(Notice::Body::ItemComponent.new) { "An item in a list" }
    assert_selector "li", text: "An item in a list"
  end
end
