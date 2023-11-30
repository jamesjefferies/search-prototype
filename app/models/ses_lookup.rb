class SesLookup < ApiCall
  attr_reader :input_data

  BASE_API_URI = "https://api.parliament.uk/ses/"

  # Note that this class has been refactored to operate on the 'standard data structure' (one or more hashes
  # of value and field_name) used elsewhere in the application:
  # [{value: w, field_name: 'x'}, { value: 'y', field_name: 'z'}...]

  def initialize(input_data)
    @input_data = input_data
  end

  def lookup_ids
    # extract all of the values (which should be integers) from the hashes
    input_data.map { |h| h[:value].to_i }
  end

  def lookup_string
    # TODO: limited to 250 IDs to avoid SES 404
    lookup_ids.flatten.uniq.compact.first(250).join(',')
  end

  def data
    # for returning all data in a structured format for further querying
    return unless lookup_ids.any?

    ret = {}
    evaluated_response['terms'].each do |term|
      ret[term['term']['id'].to_i] = term['term']['name']
    end
    ret
  end

  def ruby_uri
    build_uri("#{BASE_API_URI}select.exe?TBDB=disp_taxonomy&TEMPLATE=service.json&SERVICE=term&ID=#{lookup_string}")
  end
end