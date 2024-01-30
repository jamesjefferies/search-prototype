module LinkHelper
  def object_show_link(string, uri)
    # used where we have the title of an object and the link to that object in a source system
    # returns a titled link to the object show page for that url

    return if string.blank? || uri.blank?

    link_to(string, object_show_url(object: uri[:value]))
  end

  def search_link(data, singular: false)

    # Accepts either a string or a SES ID, which it resolves into a string
    # Either option requires a field reference (standard data hash)

    return if data.blank? || data[:value].blank?

    # Adjusted behaviour: all fields now pass a complete data object across, including their field name
    # This means any field, e.g. memberPrinted_t will search for the value in that Solr field. This behaviour was
    # previously exclusive to _ses fields.
    # if data[:field_name].last(3) == 'ses'
    link_to(formatted_name(data, ses_data, singular), search_path(filter: data))
    # else
    #   link_to(formatted_name(data, ses_data, singular), search_path(query: data[:value]))
    # end

  end

  def object_display_name(data, singular: true)

    # can used where the object type is dynamic by passing a SES ID
    # alternatively works with string names
    # uses standard data hash
    # e.g. secondary information title
    # does not return a link

    return if data.blank? || data[:value].blank?

    formatted_name(data, ses_data, singular)
  end

  def object_display_name_link(data, singular: true)

    # used where the object type is dynamic
    # accepts a standard data hash containing a SES ID
    # very similar to a search link, but the link text is singularised etc. to make it suitable
    # for use with object names

    return if data.blank? || data[:value].blank?

    link_to(formatted_name(data, ses_data, singular), search_path(filter: data))
  end

  def formatted_name(data, ses_data, singular)
    singular ? format_name(data, ses_data)&.singularize : format_name(data, ses_data)
  end

  private

  def format_name(data, ses_data)
    # This method processes names, handling commas and disambiguation
    # It accepts a standard data hash with a SES ID or string

    return if data.blank?

    if data[:field_name]&.last(3) == 'ses'
      # we need to get the string from the page SES data
      name_string = ses_data[data[:value].to_i]

      if name_string.nil?
        # In some edge cases, we won't have a SES name included in the page SES data. We then perform a lookup
        # for the specific ID to make sure it gets populated.
        custom_ses_lookup = SesLookup.new([data]).data
        name_string = custom_ses_lookup[data[:value].to_i]
      end
    else
      # we already have a string
      name_string = data[:value]
    end

    return if name_string.blank?

    # only for member's names containing a comma (?), optionally with disambiguation brackets
    # TODO: a full list of valid fields to be provided
    human_name_fields = ['member_ses', 'creator_ses', 'answeringMember_ses', 'tablingMember_ses', 'leadMember_ses',
                         'correspondingMinister_ses', 'askingMember_ses', 'contributor_ses', 'primarySponsor_ses',
                         'sponsor_ses']
    return name_string unless human_name_fields.include?(data[:field_name]) && name_string.include?(',')

    if name_string.include?('(')
      # handle disambiguation brackets

      disambiguation_components = name_string.split(' (')
      # 'Sharpe of Epsom, Lord (Disambiguation)' => ['Sharpe of Epsom, Lord', 'Disambiguation)']

      name_components = disambiguation_components.first.split(',')
      # ['Sharpe of Epsom', 'Lord']

      # we return as 'Lord Sharpe of Epsom (Disambiguation)'
      ret = "#{name_components.last} #{name_components.first} (#{disambiguation_components.last}"
    else
      # we get something like 'Sharpe of Epsom, Lord'
      name_components = name_string.split(',')

      # we return as 'Lord Sharpe of Epsom'
      ret = "#{name_components.last} #{name_components.first}"
    end

    ret.strip
  end

  def ses_data
    @ses_data
  end

end