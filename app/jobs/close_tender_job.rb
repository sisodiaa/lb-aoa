class CloseTenderJob < ApplicationJob
  queue_as :default

  def perform(reference_id)
    tender = Tender.find_by(reference_id: reference_id)
    tender.under_review! if tender&.published? && tender&.current?
  end
end
