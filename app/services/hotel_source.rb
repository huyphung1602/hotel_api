# frozen_string_literal: true

class HotelSource
  SUPPLIER_1 = {
    name: 'SUPPLIER_1',
    url: 'http://www.mocky.io/v2/5ebbea102e000029009f3fff',
    column_aliaes_mapping: {
      hotel_id: 'id',
      destination_id: 'destination_id',
      hotel_name: 'name',
      location: 'location',
      details: 'description',
      amenities: 'amenities',
      images: 'images',
      booking_conditions: 'booking_conditions',
    },
  }.freeze
   
  SUPPLIER_2 = {
    name: 'SUPPLIER_2',
    url: 'http://www.mocky.io/v2/5ebbea002e000054009f3ffc',
    column_aliaes_mapping: {
      id: 'id',
      destination_id: 'destination_id',
      name: 'name',
      latitude: 'lat',
      longitude: 'lng',
      address: 'address',
      city: 'city',
      country: 'country',
      postal_code: 'postal_code',
      location: 'location',
      description: 'description',
      facilities: 'amenities',
    },
  }.freeze

  SUPPLIER_3 = {
    name: 'SUPPLIER_3',
    url: 'http://www.mocky.io/v2/5ebbea1f2e00002b009f4000',
    column_aliaes_mapping: {
      id: 'id',
      destination: 'destination_id',
      name: 'name',
      lat: 'lat',
      lng: 'lng',
      address: 'address',
      info: 'description',
      amenities: 'amenities',
      images: 'images',
    },
  }.freeze

  HOTEL_SOURCES = [
    SUPPLIER_1,
    SUPPLIER_2,
    SUPPLIER_3,
  ].freeze

  class << self
    def get_sources
      HOTEL_SOURCES
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
