# frozen_string_literal: true

require "test_helper"

class Icon::Mini::CalendarDaysComponentTest < ViewComponent::TestCase
  test "that component renders mini icon for calendar with days" do
    render_inline Icon::Mini::CalendarDaysComponent.new(
      title: "Last activity on",
      fill: "currentColor",
      view_box: "0 0 20 20",
      classes: "w-5 h-5"
    )
    assert_selector "svg[fill='currentColor'][viewbox='0 0 20 20'][class='w-5 h-5']"
    assert_no_selector "svg[stroke][stroke-width]"
    assert_selector "svg title", text: "Last activity on"
  end
end
