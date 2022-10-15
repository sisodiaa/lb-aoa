# frozen_string_literal: true

require "test_helper"

class Icon::ArrowLongLeftComponentTest < ViewComponent::TestCase
  test "that component renders icon for left arrow" do
    render_inline Icon::ArrowLongLeftComponent.new(fill: "currentColor", view_box: "0 0 20 20", classes: "w-5 h-5")
    assert_selector "svg[fill='currentColor'][viewbox='0 0 20 20'][class='w-5 h-5']"
  end
end
