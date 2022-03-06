# frozen_string_literal: true

require 'rails_helper'

describe DataFilter do
  let(:vcr_match_cond) { %i[method uri host path body] }
  let(:blocks) { DataFetcher.execute('hotel_json') }

  subject { described_class.new('hotel_json', filter_columns, blocks)}

  describe '.execute' do
    context 'no filters appy' do
      let(:filter_columns) { {} }

      it 'return all the rows' do
        VCR.use_cassette('hotel_source_fetch_all_correctly', match_requests_on: vcr_match_cond) do
          filter_blocks = subject.execute
          block_1_rows = filter_blocks.first[:rows]
          block_2_rows = filter_blocks.second[:rows]
          block_3_rows = filter_blocks.last[:rows]

          expect(filter_blocks.size).to eq 3
          expect(block_1_rows.map { |row| row['hotel_id'] }).to match_array ['iJhz', 'SjyX', 'f8c9']
          expect(block_1_rows.first.keys).to match_array ['hotel_id', 'destination_id', 'hotel_name', 'location', 'details', 'amenities', 'images', 'booking_conditions']
          expect(block_2_rows.first.keys).to match_array ['Id', 'DestinationId', 'Name', 'Latitude', 'Longitude', 'Address', 'City', 'Country', 'PostalCode', 'Description', 'Facilities']
          expect(block_3_rows.first.keys).to match_array ['id', 'destination', 'name', 'lat', 'lng', 'address', 'info', 'amenities', 'images']
        end
      end
    end

    context 'apply filters on one dimension' do
      let(:filter_columns) { { destination_id: [5432] } }

      it 'return all the rows' do
        VCR.use_cassette('hotel_source_fetch_all_correctly', match_requests_on: vcr_match_cond) do
          filter_blocks = subject.execute
          block_1_rows = filter_blocks.first[:rows]
          block_2_rows = filter_blocks.second[:rows]
          block_3_rows = filter_blocks.last[:rows]

          expect(filter_blocks.size).to eq 3
          expect(block_1_rows.map { |row| row['hotel_id'] }).to match_array ['iJhz', 'SjyX']
          expect(block_2_rows.map { |row| row['Id'] }).to match_array ['iJhz', 'SjyX']
          expect(block_3_rows.map { |row| row['id'] }).to match_array ['iJhz']
        end
      end
    end

    context 'apply filters on two dimension' do
      let(:filter_columns) do
        { 
          hotel_id: ['SjyX'],
          destination_id: [5432],
        }
      end

      it 'return all the rows' do
        VCR.use_cassette('hotel_source_fetch_all_correctly', match_requests_on: vcr_match_cond) do
          filter_blocks = subject.execute
          block_1_rows = filter_blocks.first[:rows]
          block_2_rows = filter_blocks.second[:rows]
          block_3_rows = filter_blocks.last[:rows]

          expect(filter_blocks.size).to eq 3
          expect(block_1_rows.map { |row| row['hotel_id'] }).to match_array ['SjyX']
          expect(block_2_rows.map { |row| row['Id'] }).to match_array ['SjyX']
          expect(block_3_rows.map { |row| row['id'] }).to match_array []
        end
      end
    end
  end
end
