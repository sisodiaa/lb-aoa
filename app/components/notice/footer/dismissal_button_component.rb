# frozen_string_literal: true

class Notice::Footer::DismissalButtonComponent < Button::OutlineButtonComponent
  def initialize
    super(
      spacing: "px-3 py-1.5",
      typography: "font-medium text-xs",
      color: "text-blue-900 border-blue-900 hover:bg-blue-900 hover:text-white focus:outline-none focus:ring-blue-200",
      transition: "transition-color duration-300"
    )
  end
end
