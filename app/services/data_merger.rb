# frozen_string_literal: true

class DataMerger
  def initialize(source_type)
    @data_source = DataSource.get_source(source_type)
    @merger = get_merger(source_type)
  end

  def execute(raw_rows)
    merged_data_as_hash = raw_rows.each_with_object({}) do |row, hash|
      merging_row_id = data_source.get_id(row)

      merging_row = hash[merging_row_id].present? ? hash[merging_row_id] : {}
      merged_row = merger.merge!(merging_row, row)
      hash[merging_row_id] = merged_row
    end

    merged_data_as_hash.values
  end

  private

  attr_reader :data_source, :merger

  def get_merger(source_type)
    case source_type.to_sym
    when :hotel_json
      Mergers::HotelMerger
    else
      raise ::DataSourceError, 'Unsupported source type'
    end
  end
end
