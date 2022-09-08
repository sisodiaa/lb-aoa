class Membership < ApplicationRecord
  include AASM

  belongs_to :property

  enum membership_state: {
    under_review: 0,
    approved: 1,
    rejected: 2,
    archived: 3
  }

  aasm column: :membership_state, enum: true, no_direct_assignment: true do
    state :under_review, initial: true
    state :approved
    state :rejected
    state :archived

    event :approve do
      transitions from: :under_review, to: :approved
    end

    event :reject do
      transitions from: :under_review, to: :rejected
    end

    event :scrutinize do
      transitions from: :approved, to: :under_review
      transitions from: :rejected, to: :under_review
    end

    event :archiving do
      transitions from: :approved, to: :archived
    end
  end
end
