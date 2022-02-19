require 'net/http'
require 'uri'

class DataGatheringService
  class << self
    def execute(source_type:, filter:)
      fetched_data = fetch_data(source_type)
      merge_data_structure(source_type, fetched_data, filter)
    end

    def fetch_data(source_type)
      sources = DataSources.get_source(source_type)
      sources.reduce([]) do |arr, source|
        uri = URI(source)
        responses = JSON.parse(Net::HTTP.get(uri))

        if responses.is_a?(Array)
          arr += responses
        else
          raise DataGatheringServiceError, "Invalid response data, expecting parsed response as an array: #{responses.inspect}, method: fetch_data"
        end

        arr
      end
    end

    def merge_data_structure(source_type, raw_rows, filter = {})
      merger =  DataSources.get_merger(source_type)
      raw_rows.reduce({}) do |hash, row|
        if filter.present?
          next hash if filter.present? && !filter[:filter_values][merger.send("get_#{filter[:column]}", row).to_s]
        end

        merging_row_id = merger.get_id(row)

        merging_row = hash[merging_row_id].present? ? hash[merging_row_id] : {}
        merged_row = merger.merge!(merging_row, row)
        hash[merging_row_id] = merged_row
        hash
      end
    end
  end
end
