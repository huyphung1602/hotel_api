class DataFetcher
  def self.execute(source_type)
    source_urls = DataSource.get_source(source_type).get_source_urls
    source_urls.reduce([]) do |arr, url|
      uri = URI(url)
      responses = JSON.parse(Net::HTTP.get(uri))

      if responses.is_a?(Array)
        arr += responses
      else
        raise DataGatheringServiceError,
              "Invalid response data, expecting parsed response as an array: #{responses.inspect}, method: fetch_data"
      end

      arr
    end
  end
end