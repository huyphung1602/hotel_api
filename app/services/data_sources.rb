class DataSources
  HOTEL_SOURCE_URLS = [
    'http://www.mocky.io/v2/5ebbea102e000029009f3fff',
    'http://www.mocky.io/v2/5ebbea002e000054009f3ffc',
    'http://www.mocky.io/v2/5ebbea1f2e00002b009f4000',
  ].freeze

  class << self
    def get_source(source_type)
      case source_type.to_sym
      when :hotel
        HOTEL_SOURCE_URLS
      else
        raise 'Unsupported source type'
      end
    end

    def get_merger(source_type)
      case source_type.to_sym
      when :hotel
        HotelMerger
      else
        raise 'Unsupported source type'
      end
    end
  end
end
