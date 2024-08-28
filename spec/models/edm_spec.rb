require 'rails_helper'

RSpec.describe Edm, type: :model do
  let!(:edm) { Edm.new({}) }

  describe 'template' do
    it 'returns a string' do
      expect(edm.template).to be_a(String)
    end
  end

  describe 'object_name' do
    it 'returns object type' do
      allow(edm).to receive(:type).and_return({ value: 12345, field_name: 'type_ses' })
      expect(edm.object_name).to eq({ value: 12345, field_name: 'type_ses' })
    end
  end

  describe 'motion_text' do
    context 'where there is no data' do
      it 'returns nil' do
        expect(edm.motion_text).to be_nil
      end
    end

    context 'where there is an empty array' do
      let!(:edm) { Edm.new({ 'motionText_t' => [] }) }
      it 'returns nil' do
        expect(edm.motion_text).to be_nil
      end
    end

    context 'where data exists' do
      let!(:edm) { Edm.new({ 'motionText_t' => ['first item', 'second item'] }) }

      it 'returns the first item' do
        expect(edm.motion_text).to eq({ :field_name => "motionText_t", :value => "first item" })
      end
    end
  end

  describe 'primary_sponsor' do
    context 'where there is no data' do
      it 'returns nil' do
        expect(edm.primary_sponsor).to be_nil
      end
    end

    context 'where there is an empty array' do
      let!(:edm) { Edm.new({ 'primarySponsorPrinted_s' => [] }) }
      it 'returns nil' do
        expect(edm.primary_sponsor).to be_nil
      end
    end

    context 'where data exists' do
      let!(:edm) { Edm.new({ 'primarySponsor_ses' => [12345, 67890] }) }

      it 'returns the first item' do
        expect(edm.primary_sponsor).to eq({ :field_name => "primarySponsor_ses", :value => 12345 })
      end
    end
  end

  describe 'session' do
    context 'where there is no data' do
      it 'returns nil' do
        expect(edm.parliamentary_session).to be_nil
      end
    end

    context 'where there is an empty array' do
      let!(:edm) { Edm.new({ 'session_t' => [] }) }
      it 'returns nil' do
        expect(edm.parliamentary_session).to be_nil
      end
    end

    context 'where data exists' do
      let!(:edm) { Edm.new({ 'session_t' => ['first item', 'second item'] }) }

      it 'returns the first item' do
        expect(edm.parliamentary_session).to eq({ :field_name => "session_t", :value => "first item" })
      end
    end
  end

  describe 'reference' do
    context 'where there is no data' do
      it 'returns nil' do
        expect(edm.reference).to be_nil
      end
    end

    context 'where there is an empty array' do
      let!(:edm) { Edm.new({ 'identifier_t' => [] }) }
      it 'returns nil' do
        expect(edm.reference).to be_nil
      end
    end

    context 'where data exists' do
      let!(:edm) { Edm.new({ 'identifier_t' => ['first item', 'second item'] }) }

      it 'returns all items' do
        expect(edm.reference).to eq([{ :field_name => "identifier_t", :value => "first item" }, { :field_name => "identifier_t", :value => "second item" }])
      end
    end
  end

  describe 'other_sponsors' do
    context 'where there is no data' do
      it 'returns nil' do
        expect(edm.other_sponsors).to be_nil
      end
    end

    context 'where there is an empty array' do
      let!(:edm) { Edm.new({ 'sponsor_ses' => [] }) }
      it 'returns nil' do
        expect(edm.other_sponsors).to be_nil
      end
    end

    context 'where data exists' do
      let!(:edm) { Edm.new({ 'sponsor_ses' => ['first item', 'second item'] }) }

      it 'returns all items' do
        expect(edm.other_sponsors).to eq([{ :field_name => "sponsor_ses", :value => "first item" }, { :field_name => "sponsor_ses", :value => "second item" }])
      end
    end
  end

  describe 'registered_interest_declared?' do
    context 'where there is no data' do
      it 'returns nil' do
        expect(edm.registered_interest_declared).to be_nil
      end
    end

    context 'where there is an empty array' do
      let!(:edm) { Edm.new({ 'registeredInterest_b' => [] }) }
      it 'returns nil' do
        expect(edm.registered_interest_declared).to be_nil
      end
    end

    context 'where data exists' do
      context 'where a string representing a boolean' do
        let!(:edm) { Edm.new({ 'registeredInterest_b' => ['true'] }) }

        it 'returns the relevant boolean' do
          expect(edm.registered_interest_declared).to eq({ :field_name => "registeredInterest_b", :value => true })
        end
      end
      context 'where not a boolean value' do
        let!(:edm) { Edm.new({ 'registeredInterest_b' => ['first item', 'second item'] }) }

        it 'returns nil' do
          expect(edm.registered_interest_declared).to eq(nil)
        end
      end
    end
  end

  describe 'date_tabled' do
    context 'where there is no data' do
      it 'returns nil' do
        expect(edm.date_tabled).to be_nil
      end
    end

    context 'where there is an empty array' do
      let!(:edm) { Edm.new({ 'dateTabled_dt' => [] }) }
      it 'returns nil' do
        expect(edm.date_tabled).to be_nil
      end
    end

    context 'where data exists' do
      context 'where data is a valid date' do
        let!(:edm) { Edm.new({ 'dateTabled_dt' => [Date.today.to_s, Date.yesterday.to_s] }) }
        it 'returns a date object for the first item' do
          expect(edm.date_tabled).to eq({ :field_name => "dateTabled_dt", :value => Date.today })
        end
      end
      context 'where data is not a valid date' do
        let!(:edm) { Edm.new({ 'dateTabled_dt' => ['date', 'another date'] }) }
        it 'returns nil' do
          expect(edm.date_tabled).to eq(nil)
        end
      end
    end
  end

  describe 'subjects' do
    context 'where there is no data' do
      it 'returns nil' do
        expect(edm.subjects).to be_nil
      end
    end

    context 'where there is an empty array' do
      let!(:edm) { Edm.new({ 'subject_ses' => [] }) }
      it 'returns nil' do
        expect(edm.subjects).to be_nil
      end
    end

    context 'where data exists' do
      let!(:edm) { Edm.new({ 'subject_ses' => ['first item', 'second item'] }) }

      it 'returns all items as an array' do
        expect(edm.subjects).to eq([{ :field_name => "subject_ses", :value => "first item" }, { :field_name => "subject_ses", :value => "second item" }])
      end
    end
  end

  describe 'legislation' do
    context 'where there is no data' do
      it 'returns nil' do
        expect(edm.legislation).to be_nil
      end
    end

    context 'where there is an empty array' do
      let!(:edm) { Edm.new({ 'legislationTitle_ses' => [] }) }
      it 'returns nil' do
        expect(edm.legislation).to be_nil
      end
    end

    context 'where data exists' do
      let!(:edm) { Edm.new({ 'legislationTitle_ses' => [12345, 67890] }) }

      it 'returns all items as an array' do
        expect(edm.legislation).to eq([{ :field_name => "legislationTitle_ses", :value => 12345 }, { :field_name => "legislationTitle_ses", :value => 67890 }])
      end
    end
  end

  describe 'external_location_uri' do
    context 'where there is no data' do
      it 'returns nil' do
        expect(edm.external_location_uri).to be_nil
      end
    end

    context 'where there is an empty array' do
      let!(:edm) { Edm.new({ 'externalLocation_uri' => [] }) }
      it 'returns nil' do
        expect(edm.external_location_uri).to be_nil
      end
    end

    context 'where data exists' do
      let!(:edm) { Edm.new({ 'externalLocation_uri' => ['first item', 'second item'] }) }

      it 'returns the first item' do
        expect(edm.external_location_uri).to eq({ :field_name => "externalLocation_uri", :value => "first item" })
      end
    end
  end

  describe 'amendments' do
    context 'where there  is missing data' do
      let!(:edm) { Edm.new({}) }

      it 'returns an empty array' do
        expect(edm.amendments).to eq([])
      end
    end

    context 'where there is more than one amendment' do
      let!(:edm) { Edm.new({
                             'amendmentText_t' => ['first item', 'second item'],
                             'amendment_numberOfSignatures_s' => [20, 10],
                             'amendment_primarySponsorPrinted_t' => ['sponsor one', 'sponsor two'],
                             'amendment_primarySponsor_ses' => [54321, 76543],
                             'amendment_primarySponsorParty_ses' => [12345, 54321],
                             'identifier_t' => ['main id', 'amendment 1 id', 'amendment 2 id'],
                             'amendment_dateTabled_dt' => [DateTime.commercial(2022), DateTime.commercial(2021)],
                           }) }

      it 'returns an array containing a hash for each amendment' do
        expect(edm.amendments).to eq(
                                    [{
                                       date_tabled: { value: DateTime.commercial(2022), field_name: 'amendment_dateTabled_dt' },
                                       number_of_signatures: { value: 20, field_name: 'amendment_numberOfSignatures_s' },
                                       primary_sponsor: { value: 54321, field_name: 'amendment_primarySponsor_ses' },
                                       primary_sponsor_text: { value: 'sponsor one', field_name: 'amendment_primarySponsorPrinted_t' },
                                       primary_sponsor_party: { value: 12345, field_name: 'amendment_primarySponsorParty_ses' },
                                       reference: { value: 'amendment 1 id', field_name: 'identifier_t' },
                                       text: { value: 'first item', field_name: 'amendmentText_t' },
                                       index: 0
                                     },
                                     {
                                       date_tabled: { value: DateTime.commercial(2021), field_name: 'amendment_dateTabled_dt' },
                                       number_of_signatures: { value: 10, field_name: 'amendment_numberOfSignatures_s' },
                                       primary_sponsor: { value: 76543, field_name: 'amendment_primarySponsor_ses' },
                                       primary_sponsor_text: { value: 'sponsor two', field_name: 'amendment_primarySponsorPrinted_t' },
                                       primary_sponsor_party: { value: 54321, field_name: 'amendment_primarySponsorParty_ses' },
                                       reference: { value: 'amendment 2 id', field_name: 'identifier_t' },
                                       text: { value: 'second item', field_name: 'amendmentText_t' },
                                       index: 1
                                     }
                                    ]
                                  )
      end
    end

    context 'where all data is present for one amendment' do
      let!(:edm) { Edm.new({
                             'amendmentText_t' => ['first item'],
                             'amendment_numberOfSignatures_s' => [20],
                             'amendment_primarySponsorPrinted_t' => ['sponsor one'],
                             'amendment_primarySponsor_ses' => [23456],
                             'amendment_primarySponsorParty_ses' => [12345],
                             'identifier_t' => ['main id', 'amendment 1 id'],
                             'amendment_dateTabled_dt' => [DateTime.commercial(2022)],
                           }) }

      it 'returns all data grouped by amendment' do
        expect(edm.amendments).to eq(
                                    [{
                                       date_tabled: { value: DateTime.commercial(2022), field_name: 'amendment_dateTabled_dt' },
                                       number_of_signatures: { value: 20, field_name: 'amendment_numberOfSignatures_s' },
                                       primary_sponsor: { value: 23456, field_name: 'amendment_primarySponsor_ses' },
                                       primary_sponsor_text: { value: 'sponsor one', field_name: 'amendment_primarySponsorPrinted_t' },
                                       primary_sponsor_party: { value: 12345, field_name: 'amendment_primarySponsorParty_ses' },
                                       reference: { value: 'amendment 1 id', field_name: 'identifier_t' },
                                       text: { value: 'first item', field_name: 'amendmentText_t' },
                                       index: 0
                                     }
                                    ]
                                  )
      end
    end

    context 'where some data is missing for an amendment' do
      let!(:edm) { Edm.new({
                             'amendmentText_t' => ['first item'],
                             'amendment_numberOfSignatures_s' => [20],
                             'amendment_primarySponsorPrinted_t' => ['sponsor one'],
                             'identifier_t' => ['main id', 'amendment 1 id'],
                             'amendment_dateTabled_dt' => [DateTime.commercial(2022)],
                           }) }

      it 'returns all available data and some nil values where data is missing' do
        expect(edm.amendments).to eq(
                                    [{
                                       date_tabled: { value: DateTime.commercial(2022), field_name: 'amendment_dateTabled_dt' },
                                       number_of_signatures: { value: 20, field_name: 'amendment_numberOfSignatures_s' },
                                       primary_sponsor: { value: nil, field_name: nil },
                                       primary_sponsor_text: { value: 'sponsor one', field_name: 'amendment_primarySponsorPrinted_t' },
                                       primary_sponsor_party: { value: nil, field_name: nil },
                                       reference: { value: 'amendment 1 id', field_name: 'identifier_t' },
                                       text: { value: 'first item', field_name: 'amendmentText_t' },
                                       index: 0
                                     }
                                    ]
                                  )
      end
    end
  end

  describe 'display_link' do
    context 'no links are present' do
      let!(:edm) { Edm.new({ 'internalLocation_uri' => [], 'externalLocation_uri' => [] }) }

      it 'returns nil' do
        expect(edm.display_link).to be_nil
      end
    end

    context 'internal link is present, external link is not present' do
      let!(:edm) { Edm.new({ 'internalLocation_uri' => ['www.example.com'], 'externalLocation_uri' => [] }) }

      it 'returns nil' do
        expect(edm.display_link).to be_nil
      end
    end

    context 'internal link is present, external link is present' do
      let!(:edm) { Edm.new({ 'internalLocation_uri' => ['www.example.com'], 'externalLocation_uri' => ['www.test.com'] }) }

      it 'returns the external link' do
        expect(edm.display_link).to eq({ :field_name => "externalLocation_uri", :value => "www.test.com" })
      end
    end

    context 'internal link is not present, external link is present' do
      let!(:edm) { Edm.new({ 'internalLocation_uri' => [], 'externalLocation_uri' => ['www.test.com'] }) }

      it 'returns the external link' do
        expect(edm.display_link).to eq({ :field_name => "externalLocation_uri", :value => "www.test.com" })
      end
    end
  end

  describe 'withdrawn?' do
    context 'when state is withdrawn' do
      it 'returns true' do
        allow(edm).to receive(:state).and_return({ value: 'Withdrawn' })
        expect(edm.withdrawn?).to eq(true)
      end
    end
    context 'in any other state' do
      it 'returns true' do
        allow(edm).to receive(:state).and_return({ value: 'Open' })
        expect(edm.withdrawn?).to eq(false)
      end
    end
  end

  describe 'number_of_signatures' do
    context 'where field is populated' do
      let!(:edm) { Edm.new({ 'numberOfSignatures_t' => ['10'] }) }
      it 'returns a string' do
        expect(edm.number_of_signatures).to eq({ :field_name => "numberOfSignatures_t", :value => "10" })
      end
    end
    context 'where field is not populated' do
      it 'returns a string' do
        expect(edm.number_of_signatures).to be_nil
      end
    end
  end

  describe 'subtype' do
    context 'where field is populated' do
      let!(:edm) { Edm.new({ 'subtype_ses' => [12345] }) }
      it 'returns a type ID' do
        expect(edm.subtype).to eq({ :field_name => "subtype_ses", :value => 12345 })
      end
    end
    context 'where field is not populated' do
      it 'returns a string' do
        expect(edm.subtype).to be_nil
      end
    end
  end

end