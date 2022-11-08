# frozen_string_literal: true

require "test_helper"

class Discussion::DateTimeComponentTest < ViewComponent::TestCase
  test "that calendar icon and date or time is rendered" do
    render_inline(Discussion::DateTimeComponent.new(title: "Published at").with_content("05 Nov 2022"))

    assert_selector "svg title", text: "Published at"
    assert_selector "p", text: "05 Nov 2022"
  end
end
