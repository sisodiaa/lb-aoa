# frozen_string_literal: true

require "test_helper"

class Notice::Body::ListComponentTest < ViewComponent::TestCase
  test "that component renders an unordered list with two items" do
    render_inline(Notice::Body::ListComponent.new(classes: "space-y-2 mt-2 mb-4 text-sm text-blue-900")) do |component|
      component.with_item { "First item in a list" }
      component.with_item { "Second item in the list" }
    end

    assert_selector "ul.space-y-2.mt-2.mb-4.text-sm.text-blue-900 > li", count: 2
    assert_selector "li", text: "First item in a list"
    assert_selector "li", text: "Second item in the list"
  end
end
