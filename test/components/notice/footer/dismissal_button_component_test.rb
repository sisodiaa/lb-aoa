# frozen_string_literal: true

require "test_helper"

class Notice::Footer::DismissalButtonComponentTest < ViewComponent::TestCase
  test "that component renders a dismissal button" do
    render_inline(Notice::Footer::DismissalButtonComponent.new(spacing: "font-medium", color: "text-blue-900")) { "Dismiss" }
    assert_selector "button.font-medium.text-blue-900[data-action='element-removal#hide']", text: "Dismiss"
  end
end
