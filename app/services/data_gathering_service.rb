# frozen_string_literal: true

class DataGatheringService
  def self.execute(source_type, filter_columns)
    fetched_rows = DataFetcher.execute(source_type)
    filtered_rows = DataFilter.new(source_type, filter_columns, fetched_rows).execute
    DataMerger.new(source_type).execute(filtered_rows)
  end
end
