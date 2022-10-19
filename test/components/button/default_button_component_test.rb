# frozen_string_literal: true

require "test_helper"

class Button::DefaultButtonComponentTest < ViewComponent::TestCase
  test "that component generates a button with text and icon" do
    render_inline(Button::DefaultButtonComponent.new) do |component|
      component.with_text { "Hello" }
      component.with_icon { "Icon" }
    end

    assert_selector "button.inline-flex.text-white[type=\"button\"]", text: "Icon\n\n    \n      Hello"
  end

  test "that component generates a button with text only" do
    render_inline Button::DefaultButtonComponent.new do |c|
      c.with_text { "Hello" }
    end

    assert_no_selector "button.w-full[type=\"button\"]"
    assert_selector "button.inline-flex.text-white.px-5.text-sm.bg-lb-500[type=\"button\"]", text: "Hello"
  end

  test "that component generates a button with icon only" do
    render_inline Button::DefaultButtonComponent.new do |c|
      c.with_icon { "Icon" }
    end

    assert_selector "button.inline-flex.text-white[type=\"button\"]", text: "Icon"
  end

  test "that component generates a block button" do
    render_inline Button::DefaultButtonComponent.new(block: true) do |c|
      c.with_text { "Hello" }
    end

    assert_selector "button.w-full[type=\"button\"]", text: "Hello"
  end

  test "that component generates a small button" do
    render_inline Button::DefaultButtonComponent.new(size: :small) do |c|
      c.with_text { "Hello" }
    end

    assert_selector "button.px-3.text-xs[type=\"button\"]", text: "Hello"
  end

  test "that component generates a secondary variant button" do
    render_inline Button::DefaultButtonComponent.new(variant: :secondary) do |c|
      c.with_text { "Hello" }
    end

    assert_selector "button.bg-blue-700[type=\"button\"]", text: "Hello"
  end

  test "that component generates a success variant button" do
    render_inline Button::DefaultButtonComponent.new(variant: :success) do |c|
      c.with_text { "Hello" }
    end

    assert_selector "button.bg-emerald-600[type=\"button\"]", text: "Hello"
  end

  test "that component generates a error variant button" do
    render_inline Button::DefaultButtonComponent.new(variant: :error) do |c|
      c.with_text { "Hello" }
    end

    assert_selector "button.bg-red-600[type=\"button\"]", text: "Hello"
  end

  test "that component generates a button with type `submit`" do
    render_inline Button::DefaultButtonComponent.new(type: :submit) do |c|
      c.with_text { "Hello" }
    end

    assert_selector "button[type=\"submit\"]", text: "Hello"
  end

  test "that component generates a button with data attributes" do
    render_inline Button::DefaultButtonComponent.new(data: {
      controller: "form--submission",
      form__submission_target: "submitButton"
    }) do |c|
      c.with_text { "Hello" }
    end

    assert_selector(
      "button[data-controller=\"form--submission\"][data-form--submission-target=\"submitButton\"]",
      text: "Hello"
    )
  end
end
