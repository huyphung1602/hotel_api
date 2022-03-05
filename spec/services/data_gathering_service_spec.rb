# frozen_string_literal: true

require 'rails_helper'

describe DataGatheringService do
  let(:vcr_match_cond) { %i[method uri host path body] }
  let(:data_gathering_service) { described_class.new(source_type: 'hotel_json', filter_columns: {}) }

  describe '.execute' do
    context 'response data is valid' do
      it 'return the expected data structure' do
        VCR.use_cassette('hotel_json_DataSource', match_requests_on: vcr_match_cond) do
          merged_data = data_gathering_service.execute
          expect(merged_data.size).to eq 3
          expect(merged_data.map { |record| record['id'] }).to match_array ['iJhz', 'SjyX', 'f8c9']
          expect(merged_data.first.keys).to match_array(['location', 'id', 'destination_id', 'name', 'description',
                                                         'amenities', 'images', 'booking_conditions',])
        end
      end
    end

    context 'parsed response data is not an array' do
      before do
        allow(Net::HTTP).to receive(:get).and_return('{}')
      end

      it 'raise invalid response data' do
        expect do
          data_gathering_service.execute
        end.to raise_error(DataGatheringServiceError)
      end
    end
  end
end
