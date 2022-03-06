# frozen_string_literal: true

require 'rails_helper'

describe DataMerger do
  let(:vcr_match_cond) { %i[method uri host path body] }

  describe '.execute' do
    context 'merged data from all working sources' do
      it 'return the expected data structure' do
        VCR.use_cassette('hotel_source_fetch_all_correctly', match_requests_on: vcr_match_cond) do
          fetched_blocks = DataFetcher.execute('hotel_json')
          merged_rows = described_class.new('hotel_json').execute(fetched_blocks)

          expect(merged_rows.size).to eq 3
          expect(merged_rows.map { |row| row['id'] }).to match_array(['iJhz', 'SjyX', 'f8c9'])
          expect(merged_rows.map { |row| row['location'] }.first.keys).to match_array(['address', 'country', 'lat', 'lng', 'city'])
          expect(merged_rows.map { |row| row['images'] }.first.keys).to match_array(['rooms', 'amenities', 'site'])
          expect(merged_rows.map { |row| row['amenities'] }.first.keys).to match_array(['general', 'room'])
        end
      end
    end
  end
end
