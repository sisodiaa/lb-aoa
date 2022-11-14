# frozen_string_literal: true

class Comment::ItemDetailsComponent < ViewComponent::Base
  renders_many :metadata, Discussion::TextTupleComponent
  renders_one :comment_content
  renders_many :actions, Discussion::LinkTupleComponent

  def initialize(comment:, view:)
    @comment = comment
    @view = view
  end
end
