class ApiCall
  require 'open-uri'
  require 'net/http'

  attr_reader :object_uri

  # BASE_API_URL = "https://api.parliament.uk/test-solr/select?"
  BASE_API_URL = "https://api.parliament.uk/new-solr/select?"

  def initialize(params)
    @object_uri = params[:object_uri]
  end

  def object_data
    all_data['response']['docs']&.reject{|h| h.dig('type_ses').blank?}
  end

  def all_data
    response = evaluated_response
    return response['error'] if response.has_key?('error')

    response
  end

  private

  def api_response
    raise 'Please stub this method to avoid HTTP requests in test environment' if Rails.env.test?

    api_post_request(search_params)
  end

  def evaluated_response
    JSON.parse(api_response.body)
  end

  def build_uri(url)
    URI.parse(url)
  end

  def api_post_request(params)
    _uri = URI(BASE_API_URL).dup
    data = URI.encode_www_form(params)
    puts "POST request from #{self.class.name}: #{_uri} with data: #{params} encoded as: #{data}"
    start_time = Time.now

    ret = Net::HTTP.post(_uri, data, request_headers)
    puts "Completed POST request in #{Time.now - start_time} seconds"
    ret
  end

  def api_get_request(uri)
    puts "GET request from #{self.class.name}: #{uri}"
    start_time = Time.now
    ret = Net::HTTP.get(uri, request_headers)
    puts "Completed GET request in #{Time.now - start_time} seconds"
    ret
  end

  def api_subscription_key
    Rails.application.credentials.dig(:solr_api, :subscription_key)
  end

  def request_headers
    { 'Ocp-Apim-Subscription-Key' => api_subscription_key }
  end
end