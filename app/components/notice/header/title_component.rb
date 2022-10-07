# frozen_string_literal: true

class Notice::Header::TitleComponent < ViewComponent::Base
  def initialize(classes:)
    @classes = classes
  end
end
