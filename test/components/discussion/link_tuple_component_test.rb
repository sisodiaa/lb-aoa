# frozen_string_literal: true

require "test_helper"

class Discussion::LinkTupleComponentTest < ViewComponent::TestCase
  test "that link tuple renders an icon with text" do
    render_inline Discussion::LinkTupleComponent.new(path: "/home", class_name: "text-blue-500") do |c|
      c.with_icon { "Placeholder Icon" }
      c.with_text { "Placeholder Text" }
    end

    assert_selector "a.inline-flex.text-blue-500[href=\"/home\"]"
    assert_text "Placeholder Icon"
    assert_text "Placeholder Text"
  end

  test "that if renderable is false LinkTuple will not render" do
    render_inline Discussion::LinkTupleComponent.new(path: "/home", class_name: "text-blue-500", renderable: false) do |c|
      c.with_icon { "Placeholder Icon" }
      c.with_text { "Placeholder Text" }
    end

    assert_no_selector "a.inline-flex.text-blue-500[href=\"/home\"]"
  end
end
