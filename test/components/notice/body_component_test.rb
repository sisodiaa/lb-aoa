# frozen_string_literal: true

require "test_helper"

class Notice::BodyComponentTest < ViewComponent::TestCase
  test "that component renders an unordered list with two items" do
    render_inline(Notice::BodyComponent.new) do |component|
      component.with_body { "Body content" }
    end

    assert_text "Body content"
  end
end
