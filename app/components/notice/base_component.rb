# frozen_string_literal: true

class Notice::BaseComponent < ViewComponent::Base
  renders_one :header
  renders_one :body
  renders_one :footer

  def initialize(spacing: "", color: "")
    @spacing = spacing
    @color = color
  end

  def before_render
    @classes = [base_classes, @spacing, @color].reject(&:empty?).join(" ")
  end

  private

  def base_classes
    "border rounded-lg transition-opacity duration-700"
  end
end
