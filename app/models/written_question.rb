class WrittenQuestion < ContentObject

  def initialize(content_object_data)
    super
  end

  def template
    'search/objects/written_question'
  end

  def object_name
    "written question"
  end

  def state
    return if content_object_data['pqStatus_t'].blank?

    content_object_data['pqStatus_t'].first
  end

  def tabled?
    state == 'Tabled'
  end

  def answered?
    state == 'Answered'
  end

  def holding?
    state == 'Holding'
  end

  def answered_was_holding?
    # There is no state string for this, it must be derived
    return false unless state == 'Answered'

    return false unless holding_answer?

    return false if date_of_holding_answer.blank?

    true
  end

  def withdrawn?
    state == 'Withdrawn'
  end

  def corrected?
    # There is no state string for this, it must be derived
    # Prior to July 2014, correctedWmsMc_b flag + related links will contain a link to the correction
    # After July 2014, correctedWmsMc_b + correctingItem_uri OR correctingItem_t / s as a fallback

    # There's the potential for some confusion here at this is not mutually exclusive with the other states
    # e.g. a written question could, under this model, be answered and corrected, or tabled and corrected

    return false unless content_object_data['correctedWmsMc_b'] == 'true'

    true
  end

  def correcting_object
    # Note - this is experimental and sets up correcting_object as a written question in its own right.
    #
    # In the view, we can then call object.correcting_object.department, object.correcting_object.date_of_question and
    # object.correcting_object.correcting_member to get the information we need regarding the correction.
    #
    # This only applies to corrections before July 2014, and for corrected written questions after this date
    # this method should return nil as content_object_data['correctingItem_uri'] will be blank. We can therefore
    # check correcting_object is not nil to determine whether or not we attempt to show its data in the view.
    #
    # May need to adjust this to cache response first time around
    # Also worth noting here: we're assuming that the correcting object is a written question

    return unless corrected?

    return if content_object_data['correctingItem_uri'].blank?

    correcting_item_data = ApiCall.new(object_uri: content_object_data['correctingItem_uri']).object_data
    ContentObject.generate(correcting_item_data)
  end

  def prelim_partial
    return '/search/fragments/written_question_prelim_tabled' if tabled?

    return '/search/fragments/written_question_prelim_answered' if answered?

    return '/search/fragments/written_question_prelim_holding' if holding?

    return '/search/fragments/written_question_prelim_answered_was_holding' if answered_was_holding?

    return '/search/fragments/written_question_prelim_withdrawn' if withdrawn?

    return '/search/fragments/written_question_prelim_corrected' if corrected?

    nil
  end

  def uin
    # UIN with optional Hansard reference in same field
    return if content_object_data['identifier_t'].blank?

    content_object_data['identifier_t']
  end

  def holding_answer?
    return if content_object_data['holdingAnswer_b'].blank?

    return true if content_object_data['holdingAnswer_b'] == 'true'

    false
  end

  def date_of_question
    return if content_object_data['date_dt'].blank?

    valid_date_string = validate_date(content_object_data['date_dt'])
    return unless valid_date_string

    valid_date_string.to_date
  end

  def date_of_answer
    return if content_object_data['dateOfAnswer_dt'].blank?

    valid_date_string = validate_date(content_object_data['dateOfAnswer_dt'].first)
    return unless valid_date_string

    valid_date_string.to_date
  end

  def date_of_holding_answer
    return if content_object_data['dateOfHoldingAnswer_dt'].blank?

    valid_date_string = validate_date(content_object_data['dateOfHoldingAnswer_dt'].first)
    return unless valid_date_string

    valid_date_string.to_date
  end

  def tabling_member
    return if content_object_data['tablingMember_ses'].blank?

    content_object_data['tablingMember_ses'].first
  end

  def answering_member
    return if content_object_data['answeringMember_ses'].blank?

    content_object_data['answeringMember_ses'].first
  end

  def correcting_member
    return if content_object_data['correctingMember_ses'].blank?

    content_object_data['correctingMember_ses'].first
  end

  def answer_text
    return if content_object_data['answerText_t'].blank?

    CGI::unescapeHTML(content_object_data['answerText_t'].first)
  end

  def question_text
    return if content_object_data['questionText_t'].blank?

    CGI::unescapeHTML(content_object_data['questionText_t'].first)
  end

  def transferred?
    return if content_object_data['transferredQuestion_b'].blank?

    return true if content_object_data['transferredQuestion_b'] == 'true'

    false
  end

  def attachment
    # this is the title of the attachment, rather than a link to the resource
    # there can be multiple titles, all of which will be displayed

    return if content_object_data['attachmentTitle_t'].blank?

    content_object_data['attachmentTitle_t']
  end

  def procedure
    # no data on this currently
  end
end