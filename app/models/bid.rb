class Bid < ApplicationRecord
  belongs_to :tender, inverse_of: :bids
  before_create :set_quotation_token

  has_one :document, as: :documentable, dependent: :destroy
  accepts_nested_attributes_for :document

  validates :name, presence: true
  validates :quotation_token, uniqueness: true
  validates :document, presence: true
  validates_associated :document
  validates :email, presence: true, format: {with: URI::MailTo::EMAIL_REGEXP},
    uniqueness: {
      scope: :tender_id,
      message: "already used before to submit a bid for this tender."
    }

  def to_param
    quotation_token
  end

  private

  def set_quotation_token
    self.quotation_token = generate_quotation_token
  end

  def generate_quotation_token
    loop do
      quotation_token = SecureRandom.hex(4)
      break quotation_token unless Bid.where(quotation_token: quotation_token).exists?
    end
  end
end
