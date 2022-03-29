class Selection < ApplicationRecord
  belongs_to :tender
  belongs_to :bid

  after_create :change_tender_state

  validates :reason, presence: true
  validate :tender_includes_bid

  private

  def tender_includes_bid
    unless tender.bids.include?(bid)
      errors.add(:bid, "is not associated with the tender")
    end
  end

  def change_tender_state
    tender.reviewed!
  end
end
