# frozen_string_literal: true

require "test_helper"

class ModalComponentTest < ViewComponent::TestCase
  test "that passed content is rendered by modal component" do
    render_inline(ModalComponent.new.with_content("Form"))

    assert_selector "div[data-modal-target='modal']"
    assert_text "Form"
  end
end
