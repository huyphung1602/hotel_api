# frozen_string_literal: true

require 'rails_helper'

describe DataFetcher do
  let(:vcr_match_cond) { %i[method uri host path body] }

  describe '.execute' do
    context 'fetched data from all working sources' do
      it 'return the expected data structure' do
        VCR.use_cassette('hotel_source_fetch_all_correctly', match_requests_on: vcr_match_cond) do
          fetched_blocks = described_class.execute('hotel_json')
          block_1_rows = fetched_blocks.first[:rows]
          block_2_rows = fetched_blocks.second[:rows]
          block_3_rows = fetched_blocks.last[:rows]

          expect(fetched_blocks.size).to eq 3
          expect(block_1_rows.map { |row| row['hotel_id'] }).to match_array ['iJhz', 'SjyX', 'f8c9']
          expect(block_1_rows.first.keys).to match_array ['hotel_id', 'destination_id', 'hotel_name', 'location', 'details', 'amenities', 'images', 'booking_conditions']
          expect(block_2_rows.first.keys).to match_array ['Id', 'DestinationId', 'Name', 'Latitude', 'Longitude', 'Address', 'City', 'Country', 'PostalCode', 'Description', 'Facilities']
          expect(block_3_rows.first.keys).to match_array ['id', 'destination', 'name', 'lat', 'lng', 'address', 'info', 'amenities', 'images']
        end
      end
    end

    context 'one of the fetch source is not working correctly' do
      before do
        allow(Net::HTTP).to receive(:get).and_call_original
        supplier_2_url = URI(HotelSource::SUPPLIER_2[:url])
        allow(Net::HTTP).to receive(:get).with(supplier_2_url).and_raise('Connection error ahihi')
      end

      it 'should fetch the data for the working correctly sources' do
        VCR.use_cassette('hotel_source_fetch_all_one_error', match_requests_on: vcr_match_cond) do
          fetched_blocks = described_class.execute('hotel_json')
          block_1_rows = fetched_blocks.first[:rows]
          block_2_rows = fetched_blocks.last[:rows]

          expect(fetched_blocks.size).to eq 2
          expect(block_1_rows.map { |row| row['hotel_id'] }).to match_array ['iJhz', 'SjyX', 'f8c9']
          expect(block_1_rows.first.keys).to match_array ['hotel_id', 'destination_id', 'hotel_name', 'location', 'details', 'amenities', 'images', 'booking_conditions']
          expect(block_2_rows.first.keys).to match_array ['id', 'destination', 'name', 'lat', 'lng', 'address', 'info', 'amenities', 'images']
        end
      end
    end
  end
end
