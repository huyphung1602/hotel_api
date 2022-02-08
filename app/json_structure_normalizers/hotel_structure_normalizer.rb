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
    amenities: 'amenities',
    images: 'images',
    booking_conditions: 'booking_conditions',
  }.freeze

  class << self
    def get_column_aliases_mapping
      COLUMN_ALIASES_MAPPING
    end

    def get_id(json_data)
      json_data['id'] || json_data['hotel_id'] || json_data['Id']
    end
  end
end
