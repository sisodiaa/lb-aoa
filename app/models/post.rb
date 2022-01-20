class Post < ApplicationRecord
  include AASM

  enum publication_state: {
    draft: 0,
    finished: 1
  }

  enum visibility_state: {
    members: 0,
    visitors: 1
  }

  validates :title, presence: true, length: {maximum: 256}

  aasm(
    :publication,
    column: :publication_state,
    enum: true,
    no_direct_assignment: true
  ) do
    state :draft, initial: true
    state :finished

    event :publish do
      transitions from: :draft, to: :finished
    end
  end

  aasm(
    :visibility,
    column: :visibility_state,
    enum: true,
    no_direct_assignment: true
  ) do
    state :members, initial: true
    state :visitors

    # Casting can only be performed on a published post
    event :broadcast do
      transitions from: :members, to: :visitors, if: :publication_finished?
    end

    event :narrowcast do
      transitions from: :visitors, to: :members, if: :publication_finished?
    end
  end

  def publication_finished?
    finished?
  end
end
