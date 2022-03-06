# frozen_string_literal: true

class DataFetcher
  def self.execute(source_type)
    sources = DataSource.from_source_type(source_type).get_sources
    sources.reduce([]) do |arr, source|
      uri = URI(source[:url])
      responses = JSON.parse(Net::HTTP.get(uri))

      # We are fetching data from many sources, puts the error instead of raising it
      if responses.is_a?(Array)
        # Data from each supplier was wrapped inside a block which contain the necessary information
        arr << {
          name: source[:name],
          rows: responses,
          column_aliaes_mapping: source[:column_aliaes_mapping],
        }
      else
        Rails.logger.error "DataFetcher: Expecting parsed response as an array: #{responses.inspect}"
      end

      arr

    rescue StandardError => e
      Rails.logger.error "DataFetcher: #{e.inspect}"
      arr
    end
  end
end
