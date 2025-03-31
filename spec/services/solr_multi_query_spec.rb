require 'rails_helper'

RSpec.describe SolrMultiQuery, type: :model do
  let!(:api_call) { SolrMultiQuery.new({ object_uris: ['test_uri1', 'test_uri2', 'test_uri3'] }) }
  let!(:mock_response) { {
    "responseHeader" => {
      "status" => 0,
      "QTime" => 4,
      "params" => { "q" => "externalLocation_uri:\"test_external_location_uri\"", "wt" => "json" }
    },
    "response" => {
      "numFound" => 1,
      "start" => 0,
      "docs" => [{ 'test_string' => 'test1', 'uri' => 'test_uri1', 'all_ses' => [123, 456], 'type_ses' => [12345] },
                 { 'test_string' => 'test2', 'uri' => 'test_uri2', 'all_ses' => [456, 789], 'type_ses' => [23456] },
                 { 'test_string' => 'test3', 'uri' => 'test_uri3', 'all_ses' => [234, 567], 'type_ses' => [34567] },
      ] },
    "highlighting" => { "test_url" => {} }
  } }

  describe 'object_data' do
    it 'returns the data for the object' do
      allow(api_call).to receive(:evaluated_response).and_return(mock_response)
      expect(api_call.object_data).to match_array([{ 'test_string' => 'test1', 'uri' => 'test_uri1', 'all_ses' => [123, 456], 'type_ses' => [12345] },
                                                   { 'test_string' => 'test2', 'uri' => 'test_uri2', 'all_ses' => [456, 789], 'type_ses' => [23456] },
                                                   { 'test_string' => 'test3', 'uri' => 'test_uri3', 'all_ses' => [234, 567], 'type_ses' => [34567] },
                                                  ])
    end
  end

  describe 'object_filter' do
    it 'returns a string ' do
      allow(api_call).to receive(:evaluated_response).and_return(mock_response)
      expect(api_call.object_filter).to eq("uri:test_uri1 || uri:test_uri2 || uri:test_uri3")
    end
  end
end
