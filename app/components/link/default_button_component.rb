# frozen_string_literal: true

class Link::DefaultButtonComponent < ViewComponent::Base
  attr_reader :size

  def initialize(href: "#", variant: "primary", size: "base")
    @href = href
    @variant = variant
    @size = size
  end

  def before_render
    @class_name = [size_class, variant_class].join(" ")
  end

  renders_one :text
  renders_one :icon

  private

  def size_class
    return "px-3 py-1.5 text-xs" if size == "small"
    "px-5 py-2.5 text-sm"
  end

  def variant_class
    primary_variant_class
  end

  def primary_variant_class
    "bg-lb-500 hover:bg-lb-600 active:bg-lb-700 " \
    "shadow-sm shadow-lb-100 hover:shadow-xs hover:shadow-lb-50 active:shadow-none"
  end
end
