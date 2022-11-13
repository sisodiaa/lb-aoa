# frozen_string_literal: true

require "test_helper"

class Discussion::HeaderComponentTest < ViewComponent::TestCase
  test "that header has an icon and a heading" do
    render_inline Discussion::HeaderComponent.new(render_icon: true) do |c|
      c.with_heading(class_name: "text-lg") { "Hello, Header!" }
      c.with_icon { "Placeholder for Icon" }
    end

    assert_selector "h1.text-lg", text: "Hello, Header!"
    assert_text "Placeholder for Icon"
  end
  test "that icon is not rendered if renderable predicate is false" do
    render_inline Discussion::HeaderComponent.new(render_icon: false) do |c|
      c.with_icon { "Placeholder for Icon" }
    end

    assert_no_text "Placeholder for Icon"
  end
end
