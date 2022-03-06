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
    filters.map do |filter|
      filter_column = query_columns_mapping[filter[:column_name].to_sym]
      !!filter[:filter_values][row[filter_column].to_s]
    end.all?
  end

  def build_filter(filter_columns)
    filter_columns.map do |column_name, filter_values|
      {
        column_name: column_name.to_s,
        filter_values: filter_values.each_with_object({}) { |v, h| h[v.to_s] = true },
      }
    end
  end
end
