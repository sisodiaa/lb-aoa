# frozen_string_literal: true

require "test_helper"

class Notice::Header::TitleComponentTest < ViewComponent::TestCase
  test "that component renders h3 heading" do
    render_inline(Notice::Header::TitleComponent.new(classes: "text-lg font-medium text-blue-900")) { "Link your property" }
    assert_selector "h3.text-lg.font-medium.text-blue-900", text: "Link your property"
  end
end
