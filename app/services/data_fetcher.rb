# frozen_string_literal: true

class DataFetcher
  def self.execute(source_type)
    source_urls = DataSource.get_source(source_type).get_source_urls
    source_urls.reduce([]) do |arr, url|
      uri = URI(url)
      responses = JSON.parse(Net::HTTP.get(uri))

      # We are fetching data from many sources, puts the error instead of raising it
      if responses.is_a?(Array)
        arr += responses
      else
        Rails.logger.error "DataFetcher: Expecting parsed response as an array: #{responses.inspect}"
      end

      arr

    rescue StandardError => e
      Rails.logger.error "#{DataFetcher}: #{e.inspect}"
      arr
    end
  end
end
