# frozen_string_literal: true

class Discussion::ListItemComponent < ViewComponent::Base
  with_collection_parameter :discussion
  renders_one :metadata_activity, Discussion::TextTupleComponent
  renders_one :header, Discussion::HeaderComponent
  renders_many :metadata, Discussion::TextTupleComponent

  def initialize(discussion:)
    @discussion = discussion
  end
end
