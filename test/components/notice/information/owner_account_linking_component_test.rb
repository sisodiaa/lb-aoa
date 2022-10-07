# frozen_string_literal: true

require "test_helper"

class Notice::Information::OwnerAccountLinkingComponentTest < ViewComponent::TestCase
  setup do
    @linked_owner = owners(:confirmed_linked_owner)
    @unlinked_owner = owners(:confirmed_unlinked_owner)
  end

  teardown do
    @linked_owner = @unlinked_owner = nil
  end

  test "that component does not render information notice for linked owner" do
    render_inline(Notice::Information::OwnerAccountLinkingComponent.new(user: @linked_owner, id: "account-linking-notice"))
    assert_no_selector "div#account-linking-notice.bg-blue-50"
  end

  test "that component renders information notice for unlinked owner" do
    render_inline(Notice::Information::OwnerAccountLinkingComponent.new(
      user: @unlinked_owner, id: "account-linking-notice"
    )) do |component|
      component.with_header { "Header" }
      component.with_body { "Body" }
      component.with_footer { "Footer" }
    end

    assert_selector "div#account-linking-notice.bg-blue-50"
    assert_text "Header"
    assert_text "Body"
    assert_text "Footer"
  end
end
