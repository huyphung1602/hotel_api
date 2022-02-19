require 'rails_helper'

describe FilterBuildingService do
  describe '.generate_filter' do
    context 'column_name is present' do
      it 'returns the the filter' do
        filters = described_class.generate_filter('hotel_id', ['iJhz', 'f8c9'])

        expect(filters[:column]).to eq 'hotel_id'
        expect(filters[:filter_values]).to eq({ 'iJhz'=>true, 'f8c9'=>true })
      end
    end

    context 'column_name is present' do
      it 'return nil' do
        expect(described_class.generate_filter(nil, ['iJhz', 'f8c9'])).to eq({})
      end
    end
  end
end
