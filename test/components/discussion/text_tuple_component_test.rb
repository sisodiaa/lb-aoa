# frozen_string_literal: true

require "test_helper"

class Discussion::TextTupleComponentTest < ViewComponent::TestCase
  test "that tuples renders an icon with text" do
    render_inline Discussion::TextTupleComponent.new(class_name: "text-blue-500") do |c|
      c.with_icon { "Placeholder Icon" }
      c.with_text { "Placeholder Text" }
    end

    assert_selector "div.inline-flex.text-blue-500"
    assert_text "Placeholder Icon"
    assert_text "Placeholder Text"
  end
end
