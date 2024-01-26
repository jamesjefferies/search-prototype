require 'rails_helper'

RSpec.describe 'Search', type: :request do
  describe 'GET /search' do

    context 'a search using filters' do
      let!(:solr_search_instance) { SolrSearch.new(query: { "filter" => { "field_name" => "type_ses", "value" => "90996" } }) }
      let!(:ses_lookup_instance) { SesLookup.new('test SES lookup input') }
      let!(:item1) { { 'type_ses' => 90996, 'title_t' => 'Test item 1', 'uri' => 'test_item_1_uri' } }
      let!(:item2) { { 'type_ses' => 90996, 'title_t' => 'Test item 2', 'uri' => 'test_item_2_uri' } }
      let!(:item3) { { 'type_ses' => 90996, 'title_t' => 'Test item 3', 'uri' => 'test_item_3_uri' } }
      let!(:test_search_response) { [item1, item2, item3] }

      it 'returns http success' do
        allow(SolrSearch).to receive(:new).and_return(solr_search_instance)
        allow(solr_search_instance).to receive(:object_data).and_return(test_search_response)
        allow(solr_search_instance).to receive(:filter).and_return({ "field_name" => "type_ses", "value" => 90996 })
        allow(SesLookup).to receive(:new).and_return(ses_lookup_instance)
        allow(ses_lookup_instance).to receive(:data).and_return('test ses response')

        expect(SolrSearch).to receive(:new).with({ "filter" => { "field_name" => "type_ses", "value" => "90996" }, "controller" => "search", "action" => "index" })
        expect(solr_search_instance).to receive(:object_data)
        expect(SesLookup).to receive(:new).with([{ "field_name" => "type_ses", "value" => 90996 }])
        expect(ses_lookup_instance).to receive(:data)

        get '/search', params: { "filter" => { "field_name" => "type_ses", "value" => "90996" } }
        expect(response).to have_http_status(:ok)
      end

      it 'returns items found by search' do
        allow_any_instance_of(SolrSearch).to receive(:object_data).and_return(test_search_response)
        allow_any_instance_of(SesLookup).to receive(:data).and_return('test ses response')

        get '/search', params: { "filter" => { "field_name" => "type_ses", "value" => "90996" } }
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to include("Parliamentary search - Search results")
        expect(response.parsed_body).to include('Test item 1')
        expect(response.parsed_body).to include('http://www.example.com/objects?object=test_item_1_uri')
        expect(response.parsed_body).to include('Test item 2')
        expect(response.parsed_body).to include('http://www.example.com/objects?object=test_item_2_uri')
        expect(response.parsed_body).to include('Test item 3')
        expect(response.parsed_body).to include('http://www.example.com/objects?object=test_item_3_uri')
      end
    end

    context 'a search using a query string' do
      let!(:solr_search_instance) { SolrSearch.new(query: { "query" => 'item 2' }) }
      let!(:item1) { { 'type_ses' => 90996, 'title_t' => 'Test item 1', 'uri' => 'test_item_1_uri' } }
      let!(:item2) { { 'type_ses' => 90996, 'title_t' => 'Test item 2', 'uri' => 'test_item_2_uri' } }
      let!(:item3) { { 'type_ses' => 90996, 'title_t' => 'Test item 3', 'uri' => 'test_item_3_uri' } }
      let!(:test_search_response) { [item1, item2, item3] }

      it 'returns http success' do
        allow(SolrSearch).to receive(:new).and_return(solr_search_instance)
        allow(solr_search_instance).to receive(:object_data).and_return(test_search_response)

        expect(SolrSearch).to receive(:new).with({ "query" => "item 2", "controller" => "search", "action" => "index" })
        expect(solr_search_instance).to receive(:object_data)
        expect(SesLookup).not_to receive(:new)

        get '/search', params: { "query" => 'item 2' }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end