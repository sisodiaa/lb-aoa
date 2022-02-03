class TenderTimeFrameValidator < ActiveModel::Validator
  def validate(record)
    error_for_opening(record)
    error_for_closing(record)
    error_for_invalid_timeframe(record)
  end

  private

  def error_for_opening(record)
    record.errors.add :opening, "is required for publishing the notice" if record.opening.blank?
  end

  def error_for_closing(record)
    record.errors.add :closing, "is required for publishing the notice" if record.closing.blank?
  end

  def error_for_invalid_timeframe(record)
    record.errors.add :opening, "should be before closing" if invalid_timeframe?(record)
  end

  def invalid_timeframe?(record)
    record.opening.present? &&
      record.closing.present? &&
      record.opening >= record.closing
  end
end
