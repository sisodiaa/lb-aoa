module ActionView::RecordIdentifier
  alias_method :__record_key_for_dom_id, :record_key_for_dom_id
  private :__record_key_for_dom_id

  def record_key_for_dom_id(record)
    if record.instance_of?(Discussion)
      convert_to_model(record).to_param
    else
      __record_key_for_dom_id(record)
    end
  end
end
