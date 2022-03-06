# frozen_string_literal: true

class DataFetcher
  def self.execute(source_type)
    sources = DataSource.from_source_type(source_type).get_sources
    sources.each_with_object([]) do |source, arr|
      uri = URI(source[:url])
      responses = JSON.parse(Net::HTTP.get(uri))

      # We are fetching data from many sources, puts the error instead of raising it
      if responses.is_a?(Array)
        # Data from each supplier was wrapped inside a block which contain the necessary information
        block = source.slice(:url, :column_aliaes_mapping, :query_columns_mapping)
        block[:rows] = responses
        arr << block
      else
        Rails.logger.error "DataFetcher: Expecting parsed response as an array: #{responses.inspect}"
      end
    rescue StandardError => e
      Rails.logger.error "DataFetcher: #{e.inspect}"
    end
  end
end
