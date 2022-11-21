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

  test "that if renderable is false Link Button will not render" do
    render_inline(Link::DefaultButtonComponent.new(renderable: false)) do |component|
      component.with_text { "Hello" }
      component.with_icon { "Icon" }
    end

    assert_no_selector "a.inline-flex.text-white[href=\"#\"]"
  end

  test "that component generates a link button with text only" do
    render_inline Link::DefaultButtonComponent.new do |c|
      c.with_text { "Hello" }
    end

    assert_no_selector "a.w-full[href=\"#\"]"
    assert_selector "a.inline-flex.text-white.px-5.text-sm.bg-lb-500[href=\"#\"]", text: "Hello"
  end

  test "that component generates a link button with icon only" do
    render_inline Link::DefaultButtonComponent.new do |c|
      c.with_icon { "Icon" }
    end

    assert_selector "a.inline-flex.text-white[href=\"#\"]", text: "Icon"
  end

  test "that component generates a link block button" do
    render_inline Link::DefaultButtonComponent.new(block: true) do |c|
      c.with_text { "Hello" }
    end

    assert_selector "a.w-full[href=\"#\"]", text: "Hello"
  end

  test "that component generates a small link button" do
    render_inline Link::DefaultButtonComponent.new(size: :small) do |c|
      c.with_text { "Hello" }
    end

    assert_selector "a.px-3.text-xs[href=\"#\"]", text: "Hello"
  end

  test "that component generates a secondary variant link button" do
    render_inline Link::DefaultButtonComponent.new(variant: :secondary) do |c|
      c.with_text { "Hello" }
    end

    assert_selector "a.bg-blue-700[href=\"#\"]", text: "Hello"
  end

  test "that component generates a success variant link button" do
    render_inline Link::DefaultButtonComponent.new(variant: :success) do |c|
      c.with_text { "Hello" }
    end

    assert_selector "a.bg-emerald-600[href=\"#\"]", text: "Hello"
  end

  test "that component generates a error variant link button" do
    render_inline Link::DefaultButtonComponent.new(variant: :error) do |c|
      c.with_text { "Hello" }
    end

    assert_selector "a.bg-red-600[href=\"#\"]", text: "Hello"
  end
end
