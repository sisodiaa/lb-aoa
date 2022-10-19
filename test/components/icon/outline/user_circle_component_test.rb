# frozen_string_literal: true

require "test_helper"

class Icon::Outline::UserCircleComponentTest < ViewComponent::TestCase
  test "that component renders outline icon for user circle" do
    render_inline Icon::Outline::UserCircleComponent.new(stroke_width: 2.5, classes: "w-5 h-5")
    assert_selector "svg[fill='none'][viewbox='0 0 24 24'][stroke-width='2.5'][stroke='currentColor'][class='w-5 h-5']"
  end
end
