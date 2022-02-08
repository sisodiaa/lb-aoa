class OpenTenderJob < ApplicationJob
  queue_as :default

  def perform(reference_id)
    tender = Tender.find_by(reference_id: reference_id)
    tender.current! if tender&.published? && tender&.upcoming?
  end
end
