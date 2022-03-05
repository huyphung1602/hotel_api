# frozen_string_literal: true

class DataSource
  def self.get_source(source_type)
    case source_type.to_sym
    when :hotel_json
      HotelSource
    else
      raise ::DataSourceError, 'Unsupported source type'
    end
  end
end
