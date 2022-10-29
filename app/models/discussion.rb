class Discussion < ApplicationRecord
  include AASM

  belongs_to :owner, inverse_of: :discussions

  enum accessibility_state: {
    unlocked: 0,
    locked: 1
  }

  has_rich_text :description

  validates :subject, presence: true, length: {maximum: 256}
  validates :description, presence: true

  aasm column: :accessibility_state, enum: true, no_direct_assignment: true do
    state :unlocked, initial: true
    state :locked

    event :lock do
      transitions from: :unlocked, to: :locked
    end

    event :unlock do
      transitions from: :locked, to: :unlocked
    end
  end
end
