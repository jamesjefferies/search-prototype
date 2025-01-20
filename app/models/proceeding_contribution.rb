class ProceedingContribution < ContentObject

  def initialize(content_object_data)
    super
  end

  def associated_objects
    ids = super
    ids << proceeding_contribution_uri
    ids.compact.flatten.uniq
  end

  def self.required_solr_fields
    %w[title_t uri type_ses subtype_ses contributionText_t member_ses memberParty_ses procedural_ses legislationTitle_ses legislationTitle_t subject_ses subject_t searcherNote_t legislature_ses identifier_t place_ses date_dt]
  end

  def template
    'search/objects/proceeding_contribution'
  end

  def search_result_partial
    'search/results/proceeding_contribution'
  end

  def self.search_result_solr_fields
    # fields requested in Solr search for search results page
    %w[
    title_t uri
    contributionText_t
    member_ses memberParty_ses
    type_ses subtype_ses
    procedural_ses
    legislationTitle_ses legislationTitle_t
    subject_ses subject_t
    searcherNote_t
    date_dt identifier_t place_ses legislature_ses
    ]
  end

  def object_name
    subtype_or_type
  end

  def proceeding_contribution_uri
    fallback(get_first_id_from('parentProceeding_t'), get_first_id_from('parentProceeding_uri'))
  end
end