# frozen_string_literal: true

class DataMerger
  def self.execute(source_type, raw_rows)
    merger = get_merger(source_type)
    data_source = DataSource.get_source(source_type)

    merged_data_as_hash = raw_rows.each_with_object({}) do |row, hash|
      merging_row_id = data_source.get_id(row)

      merging_row = hash[merging_row_id].present? ? hash[merging_row_id] : {}
      merged_row = merger.merge!(merging_row, row)
      hash[merging_row_id] = merged_row
    end

    merged_data_as_hash.values
  end

  private

  def self.get_merger(source_type)
    case source_type.to_sym
    when :hotel_json
      Mergers::HotelMerger
    else
      raise ::DataSourceError, 'Unsupported source type'
    end
  end
end
