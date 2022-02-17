require 'rails_helper'

describe DataSources do
  describe '.get_source' do
    context 'supported source_type' do
      it 'returns the correct source' do
        expect(described_class.get_source('hotel_json')).to eq described_class::HOTEL_SOURCE_URLS
      end
    end

    context 'unsupported source_type' do
      it 'raise the Unsupported Type error' do
        expect { described_class.get_source('wibu') }.to raise_error(DataSourcesError)
      end
    end
  end

  describe '.get_merger' do
    context 'supported source_type' do
      it 'returns the correct merger' do
        expect(described_class.get_merger('hotel_json')).to eq HotelMerger
      end
    end

    context 'unsupported source_type' do
      it 'raise the Unsupported Type error' do
        expect { described_class.get_merger('gundam exia') }.to raise_error(DataSourcesError)
      end
    end
  end
end
