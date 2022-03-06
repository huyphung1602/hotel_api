# frozen_string_literal: true

require 'rails_helper'

describe DataSource do
  describe '.from_source_type' do
    subject { described_class.from_source_type(source_name) }

    context 'supported source_type' do
      let(:source_name) { 'hotel_json' }

      it 'returns the correct source' do
        expect(subject).to eq HotelSource
      end
    end

    context 'unsupported source_type' do
      let(:source_name) { 'wibu' }

      it 'raise the Unsupported Type error' do
        expect { subject }.to raise_error(DataSourceError)
      end
    end
  end
end
