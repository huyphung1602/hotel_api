require 'rails_helper'

describe DataGatheringService do
  let(:vcr_match_cond) { %i[method uri host path body] }

  describe '.fetch_data' do
    context 'correct source_type' do
      it 'return the expected raw data' do
        VCR.use_cassette('hotel_json_datasources', match_requests_on: vcr_match_cond) do
          raw_data = described_class.fetch_data('hotel_json')
          raw_data_ids = raw_data.map { |record| HotelMerger.get_id(record) }

          expect(raw_data_ids.size).to eq 8
          expect(raw_data_ids.uniq). to match_array ['iJhz', 'SjyX', 'f8c9']
        end
      end
    end

    context 'parsed response data is not an array' do
      before do
        allow(Net::HTTP).to receive(:get).and_return('{}')
      end

      it 'raise invalid response data' do
        expect { described_class.fetch_data('hotel_json') }.to raise_error(DataGatheringServiceError)
      end
    end
  end

  describe '.merge_data_structure' do
    it 'return the expected data structure' do
      VCR.use_cassette('hotel_json_datasources', match_requests_on: vcr_match_cond) do
        raw_data = described_class.fetch_data('hotel_json')
        raw_selected_rows = raw_data.select { |record| HotelMerger.get_id(record) == 'iJhz' }
        merged_data = described_class.merge_data_structure('hotel_json', raw_selected_rows)

        expect(merged_data.size).to eq 1
        expect(merged_data.first.keys).to match_array(['location', 'id', 'destination_id', 'name', 'description', 'amenities', 'images', 'booking_conditions'])
      end
    end
  end

  describe '.execute' do
    it 'return the expected data structure' do
      VCR.use_cassette('hotel_json_datasources', match_requests_on: vcr_match_cond) do
        merged_data = described_class.execute(source_type: 'hotel_json', filter: {})
        expect(merged_data.size).to eq 3
        expect(merged_data.map { |record| record['id'] }). to match_array ['iJhz', 'SjyX', 'f8c9']
        expect(merged_data.first.keys).to match_array(['location', 'id', 'destination_id', 'name', 'description', 'amenities', 'images', 'booking_conditions'])
      end
    end
  end
end
