require 'rails_helper'

describe FilterBuildingService do
  describe '#generate_filter' do
    context 'column_name is present' do
      it 'returns the the filter' do
        filters = described_class.new('hotel_id', ['iJhz', 'f8c9']).generate_filter
        expect(filters[:column]).to eq 'hotel_id'
        expect(filters[:filter_values]).to eq({ 'iJhz'=>true, 'f8c9'=>true })
      end
    end

    context 'column_name is not present' do
      it 'return nil' do
        expect(described_class.new(nil, ['iJhz', 'f8c9']).generate_filter).to eq({})
      end
    end
  end

  describe '#gernerate_query_key' do
    context 'column_name is present' do
      it 'returns the unique query key base on the filters' do
        query_key = described_class.new('hotel_id', ['iJhz', 'f8c9']).generate_query_key
        expect(query_key).to eq 'hotel_id_f8c9_iJhz'
      end
    end

    context 'column_name is not present' do
      it 'return full query key' do
        query_key = described_class.new(nil, ['iJhz', 'f8c9']).generate_query_key
        expect(query_key).to eq 'full'
      end
    end
  end
end
