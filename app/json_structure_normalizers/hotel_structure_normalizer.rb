class HotelStructureNormalizer
  COLUMN_ALIASES_MAPPING = {
    id: 'id',
    hotel_id: 'id',
    destination_id: 'destination_id',
    destination: 'destination_id',
    name: 'name',
    hotel_name: 'name',
    lat: 'lat',
    latitude: 'lat',
    lng: 'lng',
    longitude: 'lng',
    address: 'address',
    city: 'city',
    country: 'country',
    description: 'description',
    details: 'description',
    info: 'description',
    amenities: 'amenities',
    images: 'images',
    booking_conditions: 'booking_conditions',
  }.freeze

  LOCATION_GROUPING = {
    lat: true,
    lng: true,
    address: true,
    city: true,
    country: true,
  }

  ADHOC_COLUMNS_MERGE = {
    description: true,
  }.freeze

  class << self
    def get_column_aliases_mapping
      COLUMN_ALIASES_MAPPING
    end

    def get_id(json_data)
      json_data['id'] || json_data['hotel_id'] || json_data['Id']
    end

    def get_hotel_id(data)
      get_id(json_data)
    end

    def get_destination_id(json_data)
      json_data['destination_id'] || json_data['destination']
    end

    def merge!(merging_row, raw_row)
      merging_row['location'] = {} if merging_row['location'].nil?

      raw_row.each do |key, value|
        column_name = COLUMN_ALIASES_MAPPING[key.underscore.to_sym]

        next if column_name.nil?
        stripped_value = strip_value(value)

        if ADHOC_COLUMNS_MERGE[column_name.to_sym].present?
          send("merge_#{column_name}", merging_row[column_name], stripped_value)
        elsif LOCATION_GROUPING[column_name.to_sym].present?
          merging_row['location'][column_name] = merge_column(merging_row['location'][column_name], stripped_value)
        else
          merging_row[column_name] = merge_column(merging_row[column_name], stripped_value)
        end
      end

      merging_row
    end

    def strip_value(value)
      value.is_a?(String) ? value.strip : value
    end

    def merge_column(merging_row_value, value)
      merging_row_value.present? ? merging_row_value : value
    end

    # Adhoc codes for description
    def merge_description(merging_row_description, raw_row_description)
      return raw_row_description if merging_row_description.nil?
      longer_description = merging_row_description.size > raw_row_description.size ? merging_row_description : raw_row_description
      longer_description
    end
  end
end
