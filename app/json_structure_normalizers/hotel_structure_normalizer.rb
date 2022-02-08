class HotelStructureNormalizer
  COLUMN_ALIASES_MAPPING = {
    id: 'id',
    hotel_id: 'id',
    destination_id: 'destination_id',
    destination: 'destination_id',
    name: 'name',
    hotel_name: 'name',
    lat: 'latitude',
    latitude: 'latitude',
    lng: 'longitude',
    longitude: 'longitude',
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

  ADHOC_COLUMNS_MERGE = {
    'description': true,
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
      raw_row.each do |key, value|
        column_name = COLUMN_ALIASES_MAPPING[key.underscore.to_sym]

        next if column_name.nil?

        if !merging_row[column_name].present?
          if ADHOC_COLUMNS_MERGE[column_name].present?
            send("merge_#{column_name}", merging_row[column_name], value)
          else
            merging_row[column_name] = value
          end
        end
      end

      merging_row
    end

    # Adhoc codes for description
    def merge_description(merging_row_description, raw_row_description)
      longer_description = merging_row_description.size > raw_row_description.size ? merging_row_description : raw_row_description
      longer_description
    end
  end
end
