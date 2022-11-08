# frozen_string_literal: true

class Discussion::DateTimeComponent < ViewComponent::Base
  def initialize(title:)
    @title = title
  end
end
