module ApplicationHelper
  include Pagy::Frontend

  def transition_actions(status)
    return ["approve", "reject"] if status == "under_review"
    ["archive"]
  end
end
