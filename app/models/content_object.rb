class ContentObject

  attr_reader :content_object_data

  def initialize(content_object_data)
    @content_object_data = content_object_data
  end

  def self.generate(content_object_data)
    # takes object data as an argument and returns an instance of the correct object subclass

    content_type_ses_id = content_object_data['type_ses']&.first

    content_object_class(content_type_ses_id).classify.constantize.new(content_object_data)
  end

  def ses_lookup_ids
    return if content_object_data['all_ses'].blank?

    content_object_data['all_ses']
  end

  def subtype
    return if content_object_data['subtype_ses'].blank?

    content_object_data['subtype_ses'].first
  end

  def type
    return if content_object_data['type_ses'].blank?

    content_object_data['type_ses'].first
  end

  def page_title
    # We set the page title and the content type.
    content_object_data['title_t']
  end

  def ses_data
    SesLookup.new(ses_lookup_ids).data
  end

  def html_summary
    return if content_object_data['htmlsummary_t'].blank?

    CGI::unescapeHTML(content_object_data['htmlsummary_t'].first)
  end

  def content
    return if content_object_data['content_t'].blank?

    CGI::unescapeHTML(content_object_data['content_t'].first)
  end

  def published?
    return if content_object_data['published_b'].blank?

    return false unless content_object_data['published_b'].first == 'true'

    true
  end

  def published_on
    return if content_object_data['created_dt'].blank?

    valid_date_string = validate_date(content_object_data['created_dt'].first)
    return unless valid_date_string

    valid_date_string.to_date
  end

  def reference
    # typically used for Hansard col refs
    return if content_object_data['identifier_t'].blank?

    content_object_data['identifier_t'].first
  end

  def subjects
    # TODO: may sometimes also be subject_t instead of subject_ses, need to handle this
    return if content_object_data['subject_ses'].blank?

    content_object_data['subject_ses']
  end

  def topics
    # note - have not yet verified key as missing from test data
    return if content_object_data['topic_ses'].blank?

    content_object_data['topic_ses']
  end

  def legislation
    # TODO: sometimes leigislation text will be all that is present & we need to handle this
    # by displaying it instead of a labelled link

    return if content_object_data['legislationTitle_ses'].blank?

    content_object_data['legislationTitle_ses']
  end

  def department
    return if content_object_data['department_ses'].blank?

    content_object_data['department_ses'].first
  end

  def legislature
    return if content_object_data['legislature_ses'].blank?

    content_object_data['legislature_ses'].first
  end

  def registered_interest_declared
    return if content_object_data['registeredInterest_b'].blank?

    content_object_data['registeredInterest_b'].first == 'true' ? 'Yes' : 'No'
  end

  def external_location_uri
    return if content_object_data['externalLocation_uri'].blank?

    content_object_data['externalLocation_uri'].first
  end

  def internal_location_uri
    return if content_object_data['internalLocation_uri'].blank?

    content_object_data['internalLocation_uri'].first
  end

  def content_location_uri
    return if content_object_data['contentLocation_uri'].blank?

    content_object_data['contentLocation_uri'].first
  end

  def display_link
    # For everything else, where there is no externalLocation, no Link, internalLocation is not surfaced in new Search

    external_location_uri.blank? ? nil : external_location_uri
  end

  def has_link?
    # based on discussions, we are only displaying one link

    !display_link.blank?
  end

  def notes
    return if content_object_data['searcherNote_t'].blank?

    content_object_data['searcherNote_t']
  end

  def related_items
    # based on provided information, this will return one or more URIs of related item object pages

    # if relation_t and relation_uri, gets a related item
    # fields might be inconsistent
    # link through to the item landing page

    return if content_object_data['relation_t'].blank?

    content_object_data['relation_t']
  end

  def session
    return if content_object_data['session_t'].blank?

    content_object_data['session_t'].first
  end

  private

  def self.content_object_class(ses_id)
    # TODO - expand with all IDs
    case ses_id
    when 90996
      'Edm'
    when 346697
      'ResearchBriefing'
    when 93522
      'WrittenQuestion'
    when 352211
      'WrittenStatement'
    when 347125
      'ChurchOfEnglandMeasure'
    when 352234
      'PrivateAct'
    when 347135
      'PublicAct'
    when 92034
      'MinisterialCorrection'
    when 91613
      'ImpactAssessment'
    when 347163
      'DepositedPaper'
    when 360977
      'TransportAndWorksActOrderApplication'
    when 347122
      'Bill'
    when 92435
      'Petition'
    when 347207
      'FormalProceeding'
    when 90587
      'CommandPaper'
    when 91561
      'HouseOfCommonsPaper'
    when 420548
      'EPetition'
    when 92347
      'ParliamentaryPaper'
    when 352156
      'ParliamentaryCommittee'
    when 51288
      'UnprintedPaper'
    when 352261
      'UnprintedCommandPaper'
    when 363376
      'ResearchMaterial'
    when 92277
      'OralQuestion'
    when 286676
      'OralAnswerToQuestion'
    when 356750
      'ProceedingContribution'
    when 352161
      'GrandCommitteeProceeding'
    when 352151
      'CommitteeProceeding'
    when 352179
      'ParliamentaryProceeding'
    when 347226
      'StatutoryInstrument'
    when 347028
      'EuropeanDepositedDocument'
    when 347036
      'EuropeanScrutinyExplanatoryMemorandum'
    when 347040
      'EuropeanScrutinyMinisterialCorrespondence'
    when 347032
      'EuropeanScrutinyRecommendation'
    when 347010
      'EuropeanMaterial'

    else
      'ContentObject'
    end
  end

  def validate_date(date)
    begin
      date_string = Date.parse(date)
    rescue Date::Error
      return nil
    end

    date_string
  end

end