require 'rails_helper'

describe DataGatheringService do
  describe '.fetch_data' do
    let(:vcr_match_cond) { %i[method uri host path body] }

    context 'correct source_type' do

      it 'return the expected raw data' do
        VCR.use_cassette('hotel_json_datasources', match_requests_on: vcr_match_cond) do
          raw_data = described_class.fetch_data('hotel_json')
          raw_data_ids = raw_data.map { |record| record['id'] || record['hotel_id'] || record['Id'] }

          expect(raw_data_ids.size).to eq 8
          expect(raw_data_ids.uniq). to match_array ['iJhz', 'SjyX', 'f8c9']
        end
      end
    end
  end
end
