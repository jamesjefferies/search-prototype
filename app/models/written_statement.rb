class WrittenStatement < ContentObject

  def initialize(content_object_data)
    super
  end

  def template
    'search/objects/written_statement'
  end

  def object_name
    'written statement'
  end

  def attachment
    return if content_object_data['attachment_t'].blank?

    content_object_data['attachment_t']
  end

  def notes
    return if content_object_data['notes_t'].blank?

    content_object_data['notes_t'].first
  end

  def statement_date
    return if content_object_data['date_dt'].blank?

    valid_date_string = validate_date(content_object_data['date_dt'])
    return unless valid_date_string

    valid_date_string.to_date
  end

  def corrected?
    return if content_object_data['correctedWmsMc_b'].blank?

    return true if content_object_data['correctedWmsMc_b'] == 'true'

    false
  end
end