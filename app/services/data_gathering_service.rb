# frozen_string_literal: true

class DataGatheringService
  def self.execute(source_type, filter_columns)
    fetched_blocks = DataFetcher.execute(source_type)
    filtered_blocks = DataFilter.new(filter_columns, fetched_blocks).execute
    DataMerger.new(source_type).execute(filtered_blocks)
  end
end
