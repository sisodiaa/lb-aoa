# frozen_string_literal: true

require "test_helper"

class Notice::Information::OwnerProfileNoticeComponentTest < ViewComponent::TestCase
  setup do
    @complete_profile = profiles(:owner_six)
    @incomplete_profile = profiles(:owner_seven)
  end

  teardown do
    @complete_profile = @incomplete_profile = nil
  end

  test "that component does not render information notice for complete profile" do
    render_inline(Notice::Information::OwnerProfileNoticeComponent.new(profile: @complete_profile, id: "profile-notice"))
    assert_no_selector "div#profile-notice.bg-blue-50"
  end

  test "that component renders information notice for incomplete profile" do
    render_inline(Notice::Information::OwnerProfileNoticeComponent.new(
      profile: @incomplete_profile, id: "profile-notice"
    )) do |component|
      component.with_header { "Header" }
      component.with_body { "Body" }
      component.with_footer { "Footer" }
    end

    assert_selector "div#profile-notice.bg-blue-50"
    assert_text "Header"
    assert_text "Body"
    assert_text "Footer"
  end
end
