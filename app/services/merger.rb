class Merger
  def self.get_merger(source_type)
    case source_type.to_sym
    when :hotel_json
      Mergers::HotelMerger
    else
      raise ::DataSourceError, 'Unsupported source type'
    end
  end
end
