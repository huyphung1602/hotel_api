# frozen_string_literal: true

require 'rails_helper'

describe DataSource do
  describe '.get_source' do
    context 'supported source_type' do
      it 'returns the correct source' do
        expect(described_class.get_source('hotel_json')).to eq described_class::HOTEL_SOURCE_URLS
      end
    end

    context 'unsupported source_type' do
      it 'raise the Unsupported Type error' do
        expect { described_class.get_source('wibu') }.to raise_error(DataSourceError)
      end
    end
  end
end
