require 'rails_helper'

RSpec.describe 'Research Briefing', type: :request do
  describe 'GET /show' do
    let!(:research_briefing_instance) { ResearchBriefing.new('test') }

    it 'returns http success' do
      allow_any_instance_of(SolrQuery).to receive(:all_data).and_return({ 'response' => { "docs" => ['test'] } })
      allow_any_instance_of(SolrMultiQuery).to receive(:object_data).and_return([])
      allow_any_instance_of(SesLookup).to receive(:data).and_return({})
      allow(ContentObject).to receive(:generate).and_return(research_briefing_instance)
      get '/objects', params: { :object => 'test_string' }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'test data' do
    test_data = JSON.parse(File.read("spec/fixtures/research_briefing_test_data.json"))
    docs = test_data["response"]["docs"]

    docs.each_with_index do |doc, index|
      context "object #{index}" do
        let(:data) { doc }

        it 'displays the expected data' do
          research_briefing_instance = ResearchBriefing.new(data)

          # SES response mocking requires the correct IDs so we're populating it during the test
          test_ses_data = {}

          unless research_briefing_instance.topics.blank?
            research_briefing_instance.topics.each do |topic|
              test_ses_data[topic[:value]] = "SES response for #{topic[:value]}"
            end
          end

          unless research_briefing_instance.subjects.blank?

            research_briefing_instance.subjects.each do |subject|
              test_ses_data[subject[:value]] = "SES response for #{subject[:value]}"
            end
          end

          unless research_briefing_instance.legislation.blank?
            research_briefing_instance.legislation.each do |legislation|
              test_ses_data[legislation[:value]] = "SES response for #{legislation[:value]}"
            end
          end

          allow_any_instance_of(SolrQuery).to receive(:all_data).and_return({ 'response' => { "docs" => ['test'] } })
          allow_any_instance_of(SolrMultiQuery).to receive(:object_data).and_return([])
          allow(ContentObject).to receive(:generate).and_return(research_briefing_instance)
          allow_any_instance_of(SesLookup).to receive(:data).and_return(test_ses_data)

          get '/objects', params: { :object => research_briefing_instance }

          research_briefing_instance.reference.each do |ref|
            expect(CGI::unescapeHTML(response.body)).to include(ref[:value])
          end

          unless research_briefing_instance.display_link.blank?
            expect(CGI::unescapeHTML(response.body)).to include(research_briefing_instance.display_link[:value])
          end

          if research_briefing_instance.is_published
            expect(CGI::unescapeHTML(response.body)).to include('Published by')
          end

          unless research_briefing_instance.related_item_ids.blank?
            # TODO: test related items
            # research_briefing_instance.related_item_ids.each do |related_item_uri|
            #   expect(CGI::unescapeHTML(response.body)).to include(related_item_uri)
            # end
          end

          unless research_briefing_instance.subjects.blank?
            research_briefing_instance.subjects.each do |subject|
              if subject[:field_name] == 'subject_ses'
                expect(CGI::unescapeHTML(response.body)).to include("SES response for #{subject[:value]}")
              elsif subject[:field_name] == 'subject_t'
                expect(CGI::unescapeHTML(response.body)).to include(subject[:value].to_s)
              end
            end
          end

          unless research_briefing_instance.topics.blank?
            research_briefing_instance.topics.each do |topic|
              expect(CGI::unescapeHTML(response.body)).to include(topic[:value].to_s)
            end
          end

          unless research_briefing_instance.legislation.blank?
            research_briefing_instance.legislation.each do |legislation|
              if legislation[:field_name] == 'legislationTitle_ses'
                expect(CGI::unescapeHTML(response.body)).to include("SES response for #{legislation[:value]}")
              elsif legislation[:field_name] == 'legislationTitle_t'
                expect(CGI::unescapeHTML(response.body)).to include("#{legislation[:value]}")
              end
            end
          end
        end
      end
    end
  end
end