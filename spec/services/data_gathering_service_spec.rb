# frozen_string_literal: true

require 'rails_helper'

describe DataGatheringService do
  let(:vcr_match_cond) { %i[method uri host path body] }
  subject { described_class.execute('hotel_json', {}) }

  describe '.execute' do
    context 'response data is valid' do
      it 'return the expected data structure' do
        VCR.use_cassette('hotel_source_fetch_all_correctly', match_requests_on: vcr_match_cond) do
          expect(subject.size).to eq 3
          expect(subject.map { |record| record['id'] }).to match_array ['iJhz', 'SjyX', 'f8c9']
          expect(subject.first.keys).to match_array(['location', 'id', 'destination_id', 'name', 'description',
                                                         'amenities', 'images', 'booking_conditions',])
        end
      end
    end

    context 'one of the source cannot work correctly' do
      before do
        supplier_2_url = URI(HotelSource::SUPPLIER_2[:url])
        allow(Net::HTTP).to receive(:get).and_call_original
        allow(Net::HTTP).to receive(:get).with(supplier_2_url).and_raise('Connection error ahihi')
      end

      it 'return the data from the remain sources' do
        VCR.use_cassette('hotel_source_fetch_all_one_error', match_requests_on: vcr_match_cond) do
          expect(subject.size).to eq 3
          expect(subject.map { |record| record['id'] }).to match_array ['iJhz', 'SjyX', 'f8c9']
          expect(subject.first.keys).to match_array(['location', 'id', 'destination_id', 'name', 'description',
                                                         'amenities', 'images', 'booking_conditions',])
        end
      end
    end

    context 'two of the sources cannot work correctly' do
      before do
        supplier_2_url = URI(HotelSource::SUPPLIER_2[:url])
        supplier_3_url = URI(HotelSource::SUPPLIER_3[:url])
        allow(Net::HTTP).to receive(:get).and_call_original
        allow(Net::HTTP).to receive(:get).with(supplier_2_url).and_raise('Connection error ahihi')
        allow(Net::HTTP).to receive(:get).with(supplier_3_url).and_raise('Connection error ahihi')
      end

      it 'return the data from the remain sources' do
        VCR.use_cassette('hotel_source_fetch_all_two_error', match_requests_on: vcr_match_cond) do
          expect(subject.size).to eq 3
          expect(subject.map { |record| record['id'] }).to match_array ['iJhz', 'SjyX', 'f8c9']
          expect(subject.first.keys).to match_array(['location', 'id', 'destination_id', 'name', 'description',
                                                         'amenities', 'images', 'booking_conditions',])
        end
      end
    end

    context 'all sources cannot work correctly' do
      before do
        allow(Net::HTTP).to receive(:get).and_raise('Connection error ahihi')
      end

      it 'return no data' do
        VCR.use_cassette('hotel_source_fetch_all_error', match_requests_on: vcr_match_cond) do
          expect(subject.size).to eq 0
          expect(subject.map { |record| record['id'] }).to match_array []
        end
      end
    end
  end
end
