require 'rails_helper'

RSpec.describe ParliamentaryPaperLaid, type: :model do
  let!(:parliamentary_paper_laid) { ParliamentaryPaperLaid.new({}) }

  describe 'template' do
    it 'returns a string' do
      expect(parliamentary_paper_laid.template).to be_a(String)
    end
  end

  describe 'object_name' do
    it 'returns a string' do
      expect(parliamentary_paper_laid.object_name).to be_a(String)
    end
  end

  describe 'reference' do
    context 'where there is no data' do
      it 'returns nil' do
        expect(parliamentary_paper_laid.reference).to be_nil
      end
    end

    context 'where there is an empty array' do
      let!(:parliamentary_paper_laid) { ParliamentaryPaperLaid.new({ 'identifier_t' => [] }) }
      it 'returns nil' do
        expect(parliamentary_paper_laid.reference).to be_nil
      end
    end

    context 'where data exists' do
      let!(:parliamentary_paper_laid) { ParliamentaryPaperLaid.new({ 'identifier_t' => ['first item', 'second item'] }) }

      it 'returns the first item' do
        expect(parliamentary_paper_laid.reference).to eq('first item')
      end
    end
  end

  describe 'subjects' do
    context 'where there is no data' do
      it 'returns nil' do
        expect(parliamentary_paper_laid.subjects).to be_nil
      end
    end

    context 'where there is an empty array' do
      let!(:parliamentary_paper_laid) { ParliamentaryPaperLaid.new({ 'subject_ses' => [] }) }
      it 'returns nil' do
        expect(parliamentary_paper_laid.subjects).to be_nil
      end
    end

    context 'where data exists' do
      let!(:parliamentary_paper_laid) { ParliamentaryPaperLaid.new({ 'subject_ses' => ['first item', 'second item'] }) }

      it 'returns all items as an array' do
        expect(parliamentary_paper_laid.subjects).to eq(['first item', 'second item'])
      end
    end
  end

  describe 'legislation' do
    context 'where there is no data' do
      it 'returns nil' do
        expect(parliamentary_paper_laid.legislation).to be_nil
      end
    end

    context 'where there is an empty array' do
      let!(:parliamentary_paper_laid) { ParliamentaryPaperLaid.new({ 'legislationTitle_ses' => [] }) }
      it 'returns nil' do
        expect(parliamentary_paper_laid.legislation).to be_nil
      end
    end

    context 'where data exists' do
      let!(:parliamentary_paper_laid) { ParliamentaryPaperLaid.new({ 'legislationTitle_ses' => [12345, 67890] }) }

      it 'returns all items as an array' do
        expect(parliamentary_paper_laid.legislation).to eq([12345, 67890])
      end
    end
  end
end