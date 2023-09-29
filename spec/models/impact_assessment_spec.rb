require 'rails_helper'

RSpec.describe ImpactAssessment, type: :model do
  let!(:impact_assessment) { ImpactAssessment.new({}) }

  describe 'template' do
    it 'returns a string' do
      expect(impact_assessment.template).to be_a(String)
    end
  end

  describe 'object_name' do
    it 'returns a string' do
      expect(impact_assessment.object_name).to be_a(String)
    end
  end

  describe 'reference' do
    context 'where there is no data' do
      it 'returns nil' do
        expect(impact_assessment.reference).to be_nil
      end
    end

    context 'where there is an empty array' do
      let!(:impact_assessment) { ImpactAssessment.new({ 'identifier_t' => [] }) }
      it 'returns nil' do
        expect(impact_assessment.reference).to be_nil
      end
    end

    context 'where data exists' do
      let!(:impact_assessment) { ImpactAssessment.new({ 'identifier_t' => ['first item', 'second item'] }) }

      it 'returns the first item' do
        expect(impact_assessment.reference).to eq('first item')
      end
    end
  end

  describe 'subjects' do
    context 'where there is no data' do
      it 'returns nil' do
        expect(impact_assessment.subjects).to be_nil
      end
    end

    context 'where there is an empty array' do
      let!(:impact_assessment) { ImpactAssessment.new({ 'subject_ses' => [] }) }
      it 'returns nil' do
        expect(impact_assessment.subjects).to be_nil
      end
    end

    context 'where data exists' do
      let!(:impact_assessment) { ImpactAssessment.new({ 'subject_ses' => ['first item', 'second item'] }) }

      it 'returns all items as an array' do
        expect(impact_assessment.subjects).to eq(['first item', 'second item'])
      end
    end
  end

  describe 'legislation' do
    context 'where there is no data' do
      it 'returns nil' do
        expect(impact_assessment.legislation).to be_nil
      end
    end

    context 'where there is an empty array' do
      let!(:impact_assessment) { ImpactAssessment.new({ 'legislationTitle_ses' => [] }) }
      it 'returns nil' do
        expect(impact_assessment.legislation).to be_nil
      end
    end

    context 'where data exists' do
      let!(:impact_assessment) { ImpactAssessment.new({ 'legislationTitle_ses' => [12345, 67890] }) }

      it 'returns all items as an array' do
        expect(impact_assessment.legislation).to eq([12345, 67890])
      end
    end
  end
end