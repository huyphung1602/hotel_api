require 'net/http'
require 'uri'

class DataFetchingService
  class << self
    def fetch_data(source_type)
      sources = DataSources.get_source(source_type)
      sources.reduce([]) do |arr, source|
        uri = URI(source)
        responses = JSON.parse(Net::HTTP.get(uri))

        if responses.is_a?(Array)
          arr += responses
        else
          raise "Invalid response data: #{responses.inspect}"
        end

        arr
      end
    end
  end
end
