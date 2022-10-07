# frozen_string_literal: true

require "test_helper"

class Notice::HeaderComponentTest < ViewComponent::TestCase
  test "that component renders an icon and a title" do
    render_inline(Notice::HeaderComponent.new) do |component|
      component.with_icon { "Icon" }

      component.with_title { "Title" }
    end

    assert_selector "div.flex.items-center"
    assert_text "Icon"
    assert_text "Title"
  end
end
