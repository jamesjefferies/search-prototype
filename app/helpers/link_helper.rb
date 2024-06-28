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

    field_name = data[:field_name]
    value = data[:value]

    link_to(formatted_name(data, ses_data, singular), search_path(filter: { field_name => [value] }))
  end

  def object_display_name(data, singular: true, case_formatting: false)
    # can used where the object type is dynamic by passing a SES ID
    # alternatively works with string names
    # e.g. secondary information title
    # does not return a link

    return if data.blank? || data[:value].blank?

    formatted = formatted_name(data, ses_data, singular)

    if case_formatting
      conditional_downcase(formatted)
    else
      formatted
    end
  end

  def object_display_name_link(data, singular: true, case_formatting: false)
    return if data.blank? || data[:value].blank?

    formatted = formatted_name(data, ses_data, singular)
    field_name = data[:field_name]
    value = data[:value]

    if case_formatting
      link_to(conditional_downcase(formatted), search_path(filter: { field_name => [value] }))
    else
      link_to(formatted, search_path(filter: { field_name => [value] }))
    end
  end

  def formatted_name(data, ses_data, singular)
    singular ? format_name(data, ses_data)&.singularize : format_name(data, ses_data)
  end

  def formatted_page_title(data)
    return "Untitled" if data.blank?

    if data.is_a?(String)
      # We have a string, so just display it
      data.to_s
    elsif data.is_a?(Hash)
      return "Untitled" if data[:value].blank?

      if data[:field_name].last(4) == "_ses"
        if @ses_data.blank?
          # We have a SES ID, but no lookup
          return "Untitled"
        else
          # We have a SES ID and a populated lookup
          resolved_name = @ses_data[data[:value].to_i]
          return "Untitled #{resolved_name}"
        end
      else
        # We have a string data field
        return data[:value].to_s
      end
    end
  end

  private

  def format_name(data, ses_data)
    # This method processes names, handling commas and disambiguation
    # It accepts a standard data hash with a SES ID or string

    return if data.blank?

    if data[:field_name] && ["ses", "sesrollup"].include?(data[:field_name]&.split('_')&.last)
      # if data[:field_name]&.last(3) == 'ses'
      # we need to get the string from the page SES data
      name_string = ses_data[data[:value].to_i]

      if name_string.nil?
        if Rails.env.development?
          skip = []
          puts "Missing SES name for ID #{data[:value]}" unless skip.include?(data[:field_name])
        else
          name_string = "unknown"
        end
      end
    else
      # we already have a string
      name_string = data[:value].to_s
    end

    return if name_string.blank?

    return name_string unless human_name_fields.include?(data[:field_name]) && name_string.include?(',')

    # handle disambiguation brackets
    if name_string.include?('(')
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

  private

  def conditional_downcase(name)
    downcased = name.downcase
    downcase_exceptions.each do |lower_case, upper_case|
      downcased.gsub!(lower_case, upper_case)
    end

    downcased
  end

  def downcase_exceptions
    # having downcased entire names, we can use this list to upcase words or phrases

    {
      'house of commons' => 'House of Commons',
      'house of lords' => 'House of Lords',
      'parliament' => 'Parliament',
      'parliamentary' => 'Parliamentary',
      'parliamentary committees' => 'Parliamentary Committees',
      'european' => 'European',
      'eu' => 'European',
      'european material produced by eu institutions' => 'European material produced by EU institutions',
      'transport and works act' => 'Transport and Works Act',
      'grand committee' => 'Grand Committee',
      'church of england' => 'Church of England'
    }

  end

  def human_name_fields
    # only for member's names containing a comma (?), optionally with disambiguation brackets

    [
      'amendment_primarySponsorPrinted_t',
      'amendment_primarySponsor_ses',
      'answeringMember_ses',
      'askingMember_ses',
      'contributor_ses',
      'contributor_t',
      'correctingMember_ses',
      'correspondingMinister_t',
      'correspondingMinister_ses',
      'creator_ses',
      'creator_t',
      'leadMember_ses',
      'member_ses',
      'memberPrinted_t',
      'mep_ses',
      'personalAuthor_ses',
      'personalAuthor_t',
      'primarySponsor_ses',
      'signedMember_ses',
      'sponsor_ses',
      'tablingMember_ses',
      'witness_ses',
      'witness_t'
    ]
  end

end