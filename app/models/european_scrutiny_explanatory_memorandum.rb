class EuropeanScrutinyExplanatoryMemorandum < EuropeanScrutiny

  def initialize(content_type_object_data)
    super
  end

  def template
    'content_type_objects/object_pages/european_scrutiny_explanatory_memorandum'
  end

  def search_result_partial
    'search/results/european_scrutiny_explanatory_memorandum'
  end

  def self.search_result_solr_fields
    # fields requested in Solr search for search results page
    super << %w[
    title_t uri
    department_ses department_t
    type_ses subtype_ses
    searcherNote_t
    date_dt identifier_t legislature_ses
    ]
  end

  def object_name
    subtype_or_type
  end

  def date_received
    get_first_as_date_from('dateReceived_dt')
  end
end