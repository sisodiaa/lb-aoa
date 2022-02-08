module FlashMessagesHelper
  def flash_messages
    return if flash.empty?

    toast_wrapper
  end

  def toast_wrapper
    tag.div(
      class: "flex flex-col"
    ) do
      flash.each do |type, message|
        concat(toast(type, message))
        flash.discard(type)
      end
    end
  end

  def toast(type, message)
    tag.div(
      class: "flex items-center w-full max-w-xs p-4 text-gray-500 bg-white rounded-lg shadow "\
             "absolute top-20 right-4 transition-opacity z-20 "\
             "#{Rails.env.test? ? 'duration-300' : 'duration-1000'}",
      role: "toast",
      data: {
        controller: "toast",
        toast_target: "notification",
        toast_timeout_value: Rails.env.test? ? 0 : 5000
      }
    ) do
      concat(toast_icon_wrapper(type))
      concat(toast_body(message))
      concat(toast_close(type))
    end
  end

  def toast_icon_wrapper(type)
    tag.div(
      class: "inline-flex items-center justify-center flex-shrink-0 w-8 h-8 "\
             "rounded-lg #{toast_icon_wrapper_class(type)}"
    ) do
      concat(toast_svg(type))
    end
  end

  def toast_body(message)
    tag.div message, class: "ml-3 text-sm font-normal"
  end

  def toast_close(type)
    tag.button(
      class: "ml-auto -mx-1.5 -my-1.5 bg-white text-gray-400 hover:text-gray-900 "\
             "rounded-lg focus:ring-2 focus:ring-gray-300 p-1.5 hover:bg-gray-100"\
             "inline-flex h-8 w-8",
      type: "button",
      data: {action: "click->toast#close"},
      aria: {label: "Close"}
    ) do
      concat(tag.span("Close", class: "sr-only"))
      concat(close_svg)
    end
  end

  def toast_icon_wrapper_class(type)
    {
      notice: "text-blue-500 bg-blue-100",
      success: "text-green-500 bg-green-100",
      error: "text-red-500 bg-red-100",
      alert: "text-amber-500 bg-amber-100"
    }.stringify_keys[type.to_s] || type.to_s
  end

  def toast_svg(type)
    tag.svg(
      class: "w-6 h-6 fill-[none] stroke-current stroke-2",
      "stroke-linecap": "round",
      "stroke-linejoin": "round"
    ) do
      concat(toast_icon(type))
    end
  end

  def toast_icon(type)
    tag.use href: "/assets/feather-sprite.svg##{toast_icon_symbol(type)}"
  end

  def toast_icon_symbol(type)
    {
      notice: "info",
      success: "check-circle",
      error: "x-circle",
      alert: "alert-circle"
    }.stringify_keys[type.to_s] || type.to_s
  end

  def close_svg
    tag.svg(
      class: "w-4 h-4 fill-[none] stroke-current stroke-2",
      "stroke-linecap": "round",
      "stroke-linejoin": "round"
    ) do
      concat(close_symbol)
    end
  end

  def close_symbol
    tag.use href: "/assets/feather-sprite.svg#x"
  end
end
