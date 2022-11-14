# frozen_string_literal: true

require "test_helper"

class Comment::ItemDetailsComponentTest < ViewComponent::TestCase
  test "that an individual comment item is rendered" do
    comment = comments(:rickshaw_comment_one)
    render_inline(Comment::ItemDetailsComponent.new(comment: comment, view: :show))
    assert_selector "div##{dom_id(comment)}"
    assert_selector "div##{dom_id(comment, :metadata)}"
    assert_selector "div##{dom_id(comment, :actions)}"
  end

  test "that actions div is not rendered when comment's view is not show" do
    comment = comments(:rickshaw_comment_one)
    render_inline(Comment::ItemDetailsComponent.new(comment: comment, view: :new))
    assert_selector "div##{dom_id(comment)}"
    assert_selector "div##{dom_id(comment, :metadata)}"
    assert_no_selector "div##{dom_id(comment, :actions)}"
  end
end
