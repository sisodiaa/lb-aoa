# frozen_string_literal: true

require "test_helper"

class Comment::ItemComponentTest < ViewComponent::TestCase
  test "that an individual comment item details are rendered" do
    comment = comments(:rickshaw_comment_one)
    render_inline(Comment::ItemComponent.new(comment: comment))
    assert_selector "div##{dom_id(comment)}"
    assert_selector "div##{dom_id(comment, :content)}"
    assert_selector "div##{dom_id(comment, :metadata)}"
    assert_selector "div##{dom_id(comment, :actions)}"
  end
  test "that actions are not rendered when view is not show" do
    comment = comments(:rickshaw_comment_one)
    render_inline(Comment::ItemComponent.new(comment: comment, view: :new))
    assert_selector "div##{dom_id(comment)}"
    assert_selector "div##{dom_id(comment, :content)}"
    assert_selector "div##{dom_id(comment, :metadata)}"
    assert_no_selector "div##{dom_id(comment, :actions)}"
  end
end
