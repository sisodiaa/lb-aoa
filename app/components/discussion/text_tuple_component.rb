# frozen_string_literal: true

class Discussion::TextTupleComponent < ViewComponent::Base
  renders_one :icon
  renders_one :text

  def initialize(class_name: "", renderable: true)
    @class_name = class_name
    @renderable = renderable
  end

  def render?
    @renderable
  end
end
