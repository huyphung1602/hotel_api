require 'rails_helper'

describe Merger do
  describe '.get_merger' do
    context 'supported source_type' do
      it 'returns the correct merger' do
        expect(described_class.get_merger('hotel_json')).to eq Mergers::HotelMerger
      end
    end

    context 'unsupported source_type' do
      it 'raise the Unsupported Type error' do
        expect { described_class.get_merger('gundam exia') }.to raise_error(DataSourceError)
      end
    end
  end
end
