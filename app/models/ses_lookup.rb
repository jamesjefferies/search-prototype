class SesLookup < ApiCall
  attr_reader :input_data

  BASE_API_URL = "https://api.parliament.uk/ses/"

  # Note that this class has been refactored to operate on the 'standard data structure' (one or more hashes
  # of value and field_name) used elsewhere in the application:
  # [{value: w, field_name: 'x'}, { value: 'y', field_name: 'z'}...]

  def initialize(input_data)
    @input_data = input_data
  end

  def lookup_ids
    # extract all of the sub arrays from the hashes
    return if input_data.blank?

    input_data.map { |h| h[:value] }.flatten.uniq.compact.sort
  end

  def lookup_id_groups
    # The SES API does not support POST, so we have to make multiple get requests
    return if input_data.blank?

    ret = []

    lookup_ids.each_slice(group_size) do |slice|
      ret << slice.join(',')
    end

    ret
  end

  def evaluated_responses
    # for each chunk, make a new request, then combine the results
    # returns a (flattened) array
    output = []
    threads = []

    puts "Making #{lookup_id_groups.size} requests to SES..." if Rails.env.development?
    lookup_id_groups.each do |id_group|
      # one request per group of IDs; one thread per request
      threads << Thread.new do
        puts "Begin thread" if Rails.env.development?
        begin
          # try to parse the response as JSON & extract terms
          response = JSON.parse(api_response(id_group)).dig('terms')

          # for debugging API
          # service = "stats"
          # test_uri = build_uri("#{BASE_API_URL}select.exe?TBDB=disp_taxonomy&TEMPLATE=service.json&SERVICE=#{service}")

        rescue JSON::ParserError
          # contrary to SES API documentation, errors seem to be returned as XML regardless of specified TEMPLATE
          response = Hash.from_xml(api_response(id_group))
          puts "Error: #{response}" if Rails.env.development?
        end

        # collate responses
        output << response
      end
    end

    # wait for all threads to have finished executing
    threads.each(&:join)
    puts "All requests completed" if Rails.env.development?

    # flatten responses
    output.flatten
  end

  def data
    # for returning all data in a structured format for further querying
    return if input_data.blank?

    ret = {}
    responses = evaluated_responses

    # responses is an array of hashes
    # each hash is the parsed response from individual lookups (one per [group_size] IDs)
    # the hashes contain a nested 'term' hash containing 'id' and 'name'

    # If SES returns an error, we'll get an error key returned from evaluated_response
    return responses.first if responses.first&.has_key?(:error)

    unless responses.compact.blank?
      responses.each do |response|
        ret[response['term']['id'].to_i] = response['term']['name']
      end
    end
    ret
  end

  def hierarchy_data
    # for returning all data in a structured format for further querying
    return if input_data.blank?

    ret = {}
    responses = evaluated_responses

    # responses is an array of hashes
    # each hash is the parsed response from individual lookups (one per [group_size] IDs)
    # the hashes contain a nested 'term' hash containing 'id' and 'name'

    # If SES returns an error, we'll get an error key returned from evaluated_response
    return responses.first if responses.first&.has_key?(:error)

    unless responses.compact.blank?
      responses.each do |response|
        new_key = []
        new_key << response.dig('term', 'id')&.to_i
        new_key << response.dig('term', 'name')
        ret[new_key] = response.dig('term', 'hierarchy')
      end
    end

    ret
  end

  def ruby_uri(id_group_string, hierarchy_expanded = true)
    expand_hierarchy_int = hierarchy_expanded ? 1 : 0
    build_uri("#{BASE_API_URL}select.exe?TBDB=disp_taxonomy&TEMPLATE=service.json&expand_hierarchy=#{expand_hierarchy_int}&SERVICE=term&ID=#{id_group_string}")
  end

  private

  def group_size
    250
  end

  def api_response(id_group_string)
    raise 'Please stub this method to avoid HTTP requests in test environment' if Rails.env.test?

    api_get_request(ruby_uri(id_group_string))
  end
end