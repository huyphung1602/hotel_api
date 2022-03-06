# frozen_string_literal: true

class DataMerger
  def initialize(source_type)
    @merger = get_merger(source_type)
  end

  def execute(blocks)
    merged_data_as_hash = {}

    blocks.each do |block|
      raw_rows = block[:rows]
      column_aliaes_mapping = block[:column_aliaes_mapping]

      raw_rows.each do |row|
        merging_row_id = row[block[:query_columns_mapping][:id]]

        merging_row = merged_data_as_hash[merging_row_id].present? ? merged_data_as_hash[merging_row_id] : {}
        merged_row = merger.merge!(merging_row, row, column_aliaes_mapping)
        merged_data_as_hash[merging_row_id] = merged_row
      end
    end

    merged_data_as_hash.values
  end

  private

  attr_reader :merger

  def get_merger(source_type)
    case source_type.to_sym
    when :hotel_json
      Mergers::HotelMerger
    else
      raise ::MergersError, 'Unsupported merger type'
    end
  end
end
