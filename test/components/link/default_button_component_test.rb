# frozen_string_literal: true

require "test_helper"

class Link::DefaultButtonComponentTest < ViewComponent::TestCase
  test "that component generates a link button with text and icon" do
    render_inline(Link::DefaultButtonComponent.new) do |component|
      component.with_text { "Hello" }
      component.with_icon { "Icon" }
    end

    assert_selector "a.inline-flex.text-white[href=\"#\"]", text: "Icon\n\n    \n      Hello"
  end

  test "that component generates a link button with text only" do
    render_inline Link::DefaultButtonComponent.new do |c|
      c.with_text { "Hello" }
    end

    assert_selector "a.inline-flex.text-white[href=\"#\"]", text: "Hello"
  end

  test "that component generates a link button with icon only" do
    render_inline Link::DefaultButtonComponent.new do |c|
      c.with_icon { "Icon" }
    end

    assert_selector "a.inline-flex.text-white[href=\"#\"]", text: "Icon"
  end
end
