# frozen_string_literal: true

class Icon::Mini::AtSymbolComponent < ViewComponent::Base
  def initialize(
    fill: "none",
    view_box: "0 0 24 24",
    stroke_width: 1.5,
    stroke: "currentColor",
    classes: "w-6 h-6"
  )
    @fill = fill
    @view_box = view_box
    @stroke_width = stroke_width
    @stroke = stroke
    @classes = classes
  end
end
