# frozen_string_literal: true

class Discussion::ItemComponent < ViewComponent::Base
  def initialize(discussion:, view: :show)
    @discussion = discussion
    @view = view
  end
end
