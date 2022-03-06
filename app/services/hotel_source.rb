# frozen_string_literal: true

class HotelSource
  SUPPLIER_1 = {
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
    query_columns_mapping: {
      hotel_id: 'hotel_id',
      destination_id: 'destination_id',
      id: 'hotel_id',
    },
  }.freeze
   
  SUPPLIER_2 = {
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
      location: 'location',
      description: 'description',
      facilities: 'amenities',
    },
    query_columns_mapping: {
      hotel_id: 'Id',
      destination_id: 'DestinationId',
      id: 'Id',
    },
  }.freeze

  SUPPLIER_3 = {
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
    query_columns_mapping: {
      hotel_id: 'id',
      destination_id: 'destination',
      id: 'id',
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
  end
end
