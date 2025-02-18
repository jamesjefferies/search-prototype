require 'rails_helper'

RSpec.describe LinkHelper, type: :helper do
  describe 'search link' do
    let!(:mock_ses_data) { { 123 => 'Smith, John' } }
    let!(:input_data_type_ses) { { value: 123, field_name: 'member_ses' } }
    let!(:input_data_string) { { value: 'John Smith', field_name: 'subject_t' } }
    let!(:non_searchable_string) { { value: 'John Smith', field_name: 'memberPrinted_t' } }

    context 'for searchable fields' do
      # used for member names etc
      context 'when given nil' do
        it 'returns nil' do
          allow(helper).to receive(:ses_data).and_return(mock_ses_data)
          expect(helper.search_link(nil)).to eq(nil)
        end
      end
      context 'when given a SES ID & field name' do
        it 'returns a link to a new search using the SES ID as a filter for the given field' do
          # requires SES data to have been preloaded on the page - this is done for performance reasons
          allow(helper).to receive(:ses_data).and_return(mock_ses_data)
          expect(helper.search_link(input_data_type_ses)).to eq("<a href=\"/search?filter%5Bmember_ses%5D%5B%5D=123\">John Smith</a>")
        end
      end
      context 'when given a string value and a field name' do
        it 'returns a link to a new search using the string as a filter for the given field' do
          expect(helper.search_link(input_data_string)).to eq("<a href=\"/search?filter%5Bsubject_t%5D%5B%5D=John+Smith\">John Smith</a>")
        end
      end
      context 'for non-searchable fields' do
        it 'returns the name as a string without a link' do
          expect(helper.search_link(non_searchable_string)).to eq("John Smith")
        end
      end
    end
  end

  describe 'object_display_name' do
    # used for object names that aren't links, e.g. secondary information titles

    let!(:mock_ses_data) { { 123 => 'Early day motions' } }
    let!(:input_data_type_ses) { { value: 123, field_name: 'type_ses' } }
    let!(:input_data_string) { { value: 'Early day motions', field_name: 'type_t' } }

    context 'when given nil' do
      it 'returns nil' do
        allow(helper).to receive(:ses_data).and_return(mock_ses_data)
        expect(helper.object_display_name(nil)).to eq(nil)
      end
    end

    context 'when given a SES ID and field name' do
      # requires SES data to have been preloaded on the page - this is done for performance reasons
      context 'default behaviour' do
        it 'returns the SES name in lower case' do
          allow(helper).to receive(:ses_data).and_return(mock_ses_data)
          expect(helper.object_display_name(input_data_type_ses)).to eq('Early day motion')
        end
      end
      context 'when called with case formatting true' do
        it 'returns the SES name in lower case' do
          allow(helper).to receive(:ses_data).and_return(mock_ses_data)
          expect(helper.object_display_name(input_data_type_ses, case_formatting: true)).to eq('early day motion')
        end
        context 'where the SES data contains excluded words' do
          let!(:mock_ses_data) { { 123 => 'Church of England Measure' } }
          let!(:input_data_type_ses) { { value: 123, field_name: 'type_ses' } }
          it 'retains capitalisation for excluded words' do
            allow(helper).to receive(:ses_data).and_return(mock_ses_data)
            expect(helper.object_display_name(input_data_type_ses, case_formatting: true)).to eq('Church of England measure')
          end
        end
      end
      context 'where called with singularisation disabled' do
        let!(:mock_ses_data) { { 123 => 'Early day motions' } }
        let!(:input_data_type_ses) { { value: 123, field_name: 'type_ses' } }
        it 'returns the plural term' do
          allow(helper).to receive(:ses_data).and_return(mock_ses_data)
          expect(helper.object_display_name(input_data_type_ses, singular: false)).to eq('Early day motions')
        end
      end
    end

    context 'when given string and field name' do
      context 'default behaviour' do
        it 'returns the formatted string' do
          expect(helper.object_display_name(input_data_string)).to eq('Early day motion')
        end
      end
      context 'when called with case formatting true' do
        it 'returns the formatted string in lower case' do
          expect(helper.object_display_name(input_data_string, case_formatting: true)).to eq('early day motion')
        end
        context 'when given a string including excluded words' do
          let!(:input_data_string) { { value: 'Church of England Measure', field_name: 'type_t' } }
          it 'retains capitalisation of the excluded words' do
            expect(helper.object_display_name(input_data_string, case_formatting: true)).to eq('Church of England measure')
          end
        end
      end
      context 'where called with singularisation disabled' do
        it 'returns the plural term' do
          expect(helper.object_display_name(input_data_string, singular: false)).to eq('Early day motions')
        end
      end
    end
  end

  describe 'object_display_name_link' do
    let!(:mock_ses_data) { { 123 => 'Early day motions' } }
    let!(:input_data_type_ses) { { value: 123, field_name: 'type_ses' } }
    let!(:input_data_member_ses) { { value: 123, field_name: 'member_ses' } }
    let!(:input_data_string) { { value: 'Early day motions', field_name: 'type_t' } }

    # used in preliminary sentences; defaults to singular
    context 'when given nil' do
      it 'returns nil' do
        allow(helper).to receive(:ses_data).and_return(mock_ses_data)
        expect(helper.object_display_name_link(nil)).to eq(nil)
      end
    end
    context 'when given a non-type SES ID and field name' do
      it 'returns a link to search that SES field with the given ID' do
        # requires SES data to have been preloaded on the page - this is done for performance reasons
        allow(helper).to receive(:ses_data).and_return(mock_ses_data)
        expect(helper.object_display_name_link(input_data_member_ses)).to eq("<a href=\"/search?filter%5Bmember_ses%5D%5B%5D=123\">Early day motion</a>")
      end
    end
    context 'when given a type SES ID and field name' do
      it 'returns a link to search that SES field with the given ID' do
        # requires SES data to have been preloaded on the page - this is done for performance reasons
        allow(helper).to receive(:ses_data).and_return(mock_ses_data)
        expect(helper.object_display_name_link(input_data_type_ses)).to eq("<a href=\"/search?filter%5Btype_sesrollup%5D%5B%5D=123\">Early day motion</a>")
      end
    end
    context 'when given string and field name' do
      it 'returns a link to search using the string as a query' do
        expect(helper.object_display_name_link(input_data_string)).to eq("<a href=\"/search?filter%5Btype_t%5D%5B%5D=Early+day+motions\">Early day motion</a>")
      end
    end
    context 'when called with singularisation disabled' do
      it 'returns a link to search using the string as a query, and a plural item name' do
        expect(helper.object_display_name_link(input_data_string, singular: false)).to eq("<a href=\"/search?filter%5Btype_t%5D%5B%5D=Early+day+motions\">Early day motions</a>")
      end
    end
  end

  describe 'format_name' do
    context 'with a SES name that is not a member name' do
      let!(:mock_ses_data) { { 123 => 'Department of One, Two and Three' } }
      let!(:input_data_type_ses) { { value: 123, field_name: 'department_ses' } }

      it 'returns the name as-is' do
        expect(helper.send(:format_name, input_data_type_ses, mock_ses_data, true)).to eq("Department of One, Two and Three")
      end
    end

    context 'with a SES name that is a member name' do
      let!(:mock_ses_data) { { 123 => 'Last, First' } }
      let!(:input_data_type_ses) { { value: 123, field_name: 'answeringMember_ses' } }

      it 'returns the name correctly formatted' do
        expect(helper.send(:format_name, input_data_type_ses, mock_ses_data, true)).to eq("First Last")
      end

      context 'when reading order is disabled' do
        it 'returns the name in its original order' do
          expect(helper.send(:format_name, input_data_type_ses, mock_ses_data, false)).to eq("Last, First")
        end
      end

      context 'where there are disambiguation brackets' do
        let!(:mock_ses_data) { { 123 => 'Last, First (Constituency)' } }
        let!(:input_data_type_ses) { { value: 123, field_name: 'answeringMember_ses' } }

        it 'returns first name then last name with brackets afterwards' do
          expect(helper.send(:format_name, input_data_type_ses, mock_ses_data, true)).to eq("First Last (Constituency)")
        end
      end
    end

    context 'where the provided SES data does not include the required information' do
      let!(:mock_ses_data) { { 123 => 'Last, First' } }
      let!(:fallback_ses_data) { { 234 => 'Name, Another' } }
      let!(:input_data_type_ses) { { value: 234, field_name: 'answeringMember_ses' } }

      it 'performs a new SES lookup and returns the name correctly formatted' do
        allow_any_instance_of(SesLookup).to receive(:data).and_return(fallback_ses_data)
        expect(helper.send(:format_name, input_data_type_ses, mock_ses_data, true)).to eq("Another Name")
      end
    end

    context 'where the provided SES data does not include the required information and neither does SES' do
      let!(:mock_ses_data) { { 123 => 'Last, First' } }
      let!(:fallback_ses_data) { { 234 => 'Name, Another' } }
      let!(:input_data_type_ses) { { value: 456, field_name: 'answeringMember_ses' } }

      it 'returns "Unknown"' do
        allow_any_instance_of(SesLookup).to receive(:data).and_return(fallback_ses_data)
        expect(helper.send(:format_name, input_data_type_ses, mock_ses_data, true)).to eq("Unknown")
      end
    end
  end

end