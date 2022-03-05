# frozen_string_literal: true

class HotelSource
  HOTEL_SOURCE_URLS = [
    'http://www.mocky.io/v2/5ebbea102e000029009f3fff',
    'http://dbrr.huanhoahong',
    'http://www.mocky.io/v2/5ebbea002e000054009f3ffc',
    'http://www.mocky.io/v2/5ebbea1f2e00002b009f4000',
  ].freeze

  class << self
    def get_source_urls
      HOTEL_SOURCE_URLS
    end

    def get_id(json_data)
      json_data['id'] || json_data['hotel_id'] || json_data['Id']
    end

    def get_hotel_id(json_data)
      get_id(json_data)
    end

    def get_destination_id(json_data)
      json_data['destination_id'] || json_data['destination'] || json_data['DestinationId']
    end
  end
end
