class EuropeanScrutinyRecommendation < EuropeanScrutiny

  def initialize(content_object_data)
    super
  end

  def decision
    get_first_from('decisionType_t')
  end

  def assessment
    get_first_from('assessment_t')
  end

  def status
    get_first_from('scrutinyProgress_t')
  end

  def report_number
    get_first_from('reportTitle_t')
  end

  def is_cleared
    get_first_as_boolean_from('cleared_b')
  end

  def report_date
    get_first_as_date_from('reportDate_dt')
  end

  def debate_date
    get_first_as_date_from('debateDate_dt')
  end

  def debate_location
    get_first_from('debateLocation_t')
  end

  def template
    'search/objects/european_scrutiny_recommendation'
  end
end