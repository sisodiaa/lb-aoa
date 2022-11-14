# frozen_string_literal: true

class Comment::ItemComponent < ViewComponent::Base
  def initialize(comment:, view: :show)
    @comment = comment
    @view = view
  end
end
