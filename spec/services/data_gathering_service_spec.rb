require 'rails_helper'

describe DataGatheringService do
  let(:vcr_match_cond) { %i[method uri host path body] }

  describe '.execute' do
    context 'response data is valid' do
      it 'return the expected data structure' do
        VCR.use_cassette('hotel_json_datasources', match_requests_on: vcr_match_cond) do
          merged_data = described_class.new(source_type: 'hotel_json', filters: {}).execute
          expect(merged_data.size).to eq 3
          expect(merged_data.map { |record| record['id'] }). to match_array ['iJhz', 'SjyX', 'f8c9']
          expect(merged_data.first.keys).to match_array(['location', 'id', 'destination_id', 'name', 'description', 'amenities', 'images', 'booking_conditions'])
        end
      end
    end

    context 'parsed response data is not an array' do
      before do
        allow(Net::HTTP).to receive(:get).and_return('{}')
      end

      it 'raise invalid response data' do
        expect { described_class.new(source_type: 'hotel_json', filters: {}).execute }.to raise_error(DataGatheringServiceError)
      end
    end
  end
end
