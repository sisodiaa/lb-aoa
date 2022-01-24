class Document < ApplicationRecord
  belongs_to :documentable, polymorphic: true

  has_one_attached :file
  delegate :attached?, to: :file

  validates :annotation, length: {maximum: 50}
  validate :presence_of_attachment
  validate :size_of_attachment, if: :attached?
  validate :type_of_attachment, if: :attached?

  def presence_of_attachment
    errors.add(:file, "is not choosed") unless attached?
  end

  def size_of_attachment
    errors.add(:file, "is bigger than 5 MB") unless content_size_allowed?
  end

  def content_size_allowed?
    file.byte_size <= 5.megabytes
  end

  def type_of_attachment
    errors.add(:file, "content type is not supported") unless content_type_acceptable?
  end

  def content_type_acceptable?
    acceptable_types = ["image/jpeg", "image/png", "application/pdf"]
    acceptable_types.include?(file.content_type)
  end
end
