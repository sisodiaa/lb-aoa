# frozen_string_literal: true

class Discussion::ItemComponent < ViewComponent::Base
  def initialize(discussion:)
    @discussion = discussion
  end
end
