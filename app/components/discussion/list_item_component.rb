# frozen_string_literal: true

class Discussion::ListItemComponent < ViewComponent::Base
  with_collection_parameter :discussion

  def initialize(discussion:)
    @discussion = discussion
  end
end
