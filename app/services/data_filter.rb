# frozen_string_literal: true

class DataFilter
  def initialize(source_type, filter_columns, blocks)
    @blocks = blocks
    @filters = build_filter(filter_columns)
  end

  def execute
    blocks.map do |block|
      block[:rows] = block[:rows].map { |row| row if is_matched_row?(row, block[:query_columns_mapping]) }.compact
      block
    end
  end

  private

  attr_reader :filters, :data_source, :blocks

  def is_matched_row?(row, query_columns_mapping)
    filters.each do |filter|
      filter_column = query_columns_mapping[filter[:column_name].to_sym]
      return true unless filter[:filter_values][row[filter_column].to_s]
    end
  end

  def build_filter(filter_columns)
    filter_columns.map do |column_name, filter_values|
      {
        column_name: column_name,
        filter_values: filter_values.each_with_object({}) { |v, h| h[v] = true },
      }
    end
  end
end
