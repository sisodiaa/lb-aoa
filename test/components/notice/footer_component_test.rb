# frozen_string_literal: true

require "test_helper"

class Notice::FooterComponentTest < ViewComponent::TestCase
  test "that component renders a dismissal button" do
    render_inline(Notice::FooterComponent.new) do |component|
      component.with_dismissal_button { "Dismiss" }
    end

    assert_selector "div.flex", text: "Dismiss"
  end
end
