module ApplicationHelper

  # For formatting search result counts
  include ActiveSupport::NumberHelper

  # ## We set the date display format.
  DATE_DISPLAY_FORMAT = '%A, %e %B %Y'

  def boolean_yes_no(boolean)
    # outputs 'Yes' or 'No' strings from a boolean (an instance of Ruby TrueClass or FalseClass)
    # for presenting output of methods such as WrittenQuestion transferred?
    # Note that in most cases the partial will not be rendered except where the answer is 'Yes', but exceptions exist
    return 'Yes' if boolean && boolean[:value] == true

    'No'
  end

  def ordinal_text(index)
    case index
    when 0
      "first"
    when 1
      "second"
    when 2
      "third"
    when 3
      "fourth"
    when 4
      "fifth"
    when 5
      "sixth"
    when 6
      "seventh"
    when 7
      "eighth"
    when 8
      "ninth"
    else
      (index + 1).ordinalize
    end
  end

  def format_object_title(object_title, ses_data)
    return "Untitled" if object_title.blank?

    # object title is either a string: "Title"
    return object_title if object_title.is_a?(String)

    # or it's a SES ID and accompanying field name: {:value=>91910, :field_name=>"subtype_ses"}
    if object_title.is_a?(Hash)
      return "Untitled" if object_title.dig(:value).blank?

      ses_id = object_title.dig(:value)
      type = ses_data.dig(ses_id)&.singularize

      return type.blank? ? "Untitled" : "Untitled #{type}"
    end

    # in development, raise an error if we have any other data type
    raise "Unknown object title" if Rails.env.development?

    # or return "Untitled" in production
    "Untitled"
  end

  def filter_field_name(field)
    # returns display name for a filter field, e.g. 'Content Type' for type_ses

    field_names = {
      type_ses: 'Type',
      type_sesrollup: 'Type',
      legislature_ses: 'House',
      session_t: 'Session',
      date_dt: 'Date',
      member_ses: 'Member',
      memberParty_ses: 'Member party',
      legislativeStage_ses: 'Legislative stage',
      department_ses: 'Department',
      subject_ses: 'Subject',
      topic_ses: 'Topic',
      party_ses: 'Party',
      subtype_ses: 'Subtype',
      tablingMember_ses: 'Tabling member',
      tablingMemberParty_ses: 'Tabling member party',
      answeringMember_ses: 'Answering member',
      answeringMemberParty_ses: 'Answering member party',
      askingMember_ses: 'Asking member',
      askingMemberParty_ses: 'Asking member party',
      leadMember_ses: 'Lead member',
      leadMemberParty_ses: 'Lead member party',
      legislationTitle_ses: 'Legislation',
      memberPrinted_t: 'Member',
      procedure_t: 'Procedure',
      subject_t: 'Subject',
      legislationTitle_t: 'Legislation',
      department_t: 'Department'
    }

    field_names[field.to_sym]
  end

  def checked_field(filter_params, facet_field_name, text_field_name)
    return false if filter_params.blank?

    filter_params[facet_field_name]&.include?(text_field_name)
  end

  def remove_filter_url(params, filter_name, filter_value)
    params.except(:page).merge(filter: params[:filter].merge({ filter_name => params.dig(:filter, filter_name)&.excluding(filter_value) }))
  end

  def apply_filter_url(params, filter_name, filter_value)
    params.except(:page).merge(filter: params.dig(:filter).nil? ? { filter_name => [filter_value] } : params.dig(:filter).merge(filter_name => [filter_value, params.dig(:filter, filter_name)].compact.flatten))
  end
end