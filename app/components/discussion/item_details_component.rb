# frozen_string_literal: true

class Discussion::ItemDetailsComponent < ViewComponent::Base
  renders_one :metadata_date, Discussion::TextTupleComponent
  renders_one :header, Discussion::HeaderComponent
  renders_one :metadata_author
  renders_one :description
  renders_many :actions, Discussion::LinkTupleComponent

  def initialize(discussion:, view:)
    @discussion = discussion
    @view = view
  end
end
