# frozen_string_literal: true

require 'rails_helper'

describe FilterGenerator do
  describe '#generate_filter' do
    subject { described_class.generate_filters(filter_columns) }

    context 'empty filter_columns' do
      let(:filter_columns) { {} }
      it 'return an empty array' do
        expect(subject).to eq []
      end
    end

    context 'one filter_columns' do
      let(:filter_columns) do
        {
          souls_like: ['sekiro', 'nioh', 'dark_soul'],
        }
      end
      let(:expected_filters) do
        [
          { column_name: :souls_like, filter_values: { 'sekiro' => true, 'nioh' => true, 'dark_soul' => true } },
        ]
      end

      it 'return an empty array' do
        expect(subject).to eq expected_filters
      end
    end

    context 'two filter_columns' do
      let(:filter_columns) do
        {
          hunter: ['gon', 'hisoka', 'killua'],
          type: ['anime', 'horror', 'action'],
        }
      end
      let(:expected_filters) do
        [
          { column_name: :hunter, filter_values: { 'gon' => true, 'hisoka' => true, 'killua' => true } },
          { column_name: :type, filter_values: { 'anime' => true, 'horror' => true, 'action' => true } },
        ]
      end

      it 'return an empty array' do
        expect(subject).to eq expected_filters
      end
    end
  end
end
