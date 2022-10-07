# frozen_string_literal: true

class Notice::Body::ListComponent < ViewComponent::Base
  renders_many :items, Notice::Body::ItemComponent

  def initialize(classes:)
    @classes = classes
  end
end
