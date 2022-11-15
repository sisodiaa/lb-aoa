# frozen_string_literal: true

class Discussion::ItemDetailsComponent < ViewComponent::Base
  renders_many :metadata, Discussion::TextTupleComponent
  renders_one :header, Discussion::HeaderComponent
  renders_one :description
  renders_many :actions, Discussion::LinkTupleComponent

  def initialize(discussion:, view:)
    @discussion = discussion
    @view = view
  end
end
