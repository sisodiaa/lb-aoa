# frozen_string_literal: true

class Discussion::HeadingComponent < ViewComponent::Base
  def initialize(class_name:)
    @class_name = class_name
  end
end
