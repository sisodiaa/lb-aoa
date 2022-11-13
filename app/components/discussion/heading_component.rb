# frozen_string_literal: true

class Discussion::HeadingComponent < ViewComponent::Base
  def initialize(id: "", class_name: "")
    @id = id
    @class_name = class_name
  end
end
