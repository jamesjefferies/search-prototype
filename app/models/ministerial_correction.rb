class MinisterialCorrection < ContentObject

  def initialize(content_object_data)
    super
  end

  def template
    'search/objects/ministerial_correction'
  end

  def object_name
    'ministerial correction'
  end

  def correction_text
    return if content_object_data['correctionText_t'].blank?

    content_object_data['correctionText_t'].first
  end

  def correcting_member
    member
  end

  def correcting_member_party
    member_party
  end

  def correction_date
    return if content_object_data['date_dt'].blank?

    valid_date_string = validate_date(content_object_data['date_dt'])
    return unless valid_date_string

    valid_date_string.to_date
  end
end