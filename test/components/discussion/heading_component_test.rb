# frozen_string_literal: true

require "test_helper"

class Discussion::HeadingComponentTest < ViewComponent::TestCase
  test "that component creates a heading level 1 element" do
    render_inline Discussion::HeadingComponent.new(class_name: "text-xl").with_content("Hello, World!")
    assert_selector "h1.text-xl", text: "Hello, World!"
  end
end
