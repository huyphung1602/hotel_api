class HotelMerger
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
    facilities: 'amenities',
    images: 'images',
    booking_conditions: 'booking_conditions',
  }.freeze

  LOCATION_GROUPING = {
    lat: true,
    lng: true,
    address: true,
    city: true,
    country: true,
  }.freeze

  ADHOC_COLUMNS_MERGE = {
    description: 'merge_description',
    images: 'merge_images',
    amenities: 'merge_amenities',
  }.freeze

  class << self
    def get_column_aliases_mapping
      COLUMN_ALIASES_MAPPING
    end

    def get_id(json_data)
      json_data['id'] || json_data['hotel_id'] || json_data['Id']
    end

    def get_hotel_id(json_data)
      get_id(json_data)
    end

    def get_destination_id(json_data)
      json_data['destination_id'] || json_data['destination']
    end

    # Add location key => select_correct_columns => strip value if needded => select between adhoc merge, location merge, normal merge
    def merge!(merging_row, raw_row)
      merging_row['location'] = {} if merging_row['location'].nil?

      raw_row.each do |key, value|
        column_name = COLUMN_ALIASES_MAPPING[key.underscore.to_sym]

        next if column_name.nil?
        stripped_value = value.is_a?(String) ? value.strip : value

        if ADHOC_COLUMNS_MERGE[column_name.to_sym].present?
          merging_row[column_name] = send(ADHOC_COLUMNS_MERGE[column_name.to_sym], merging_row[column_name], stripped_value, key)
        elsif LOCATION_GROUPING[column_name.to_sym].present?
          merging_row['location'][column_name] = merge_column(merging_row['location'][column_name], stripped_value)
        else
          merging_row[column_name] = merge_column(merging_row[column_name], stripped_value)
        end
      end

      merging_row
    end

    private

    def merge_column(merging_row_value, value)
      merging_row_value.present? ? merging_row_value : value
    end

    def merge_amenities(merging_amenities_hash, amenities_value, raw_column_name)
      result = merging_amenities_hash.present? ? merging_amenities_hash : {'general' => [], 'room' => []}

      if raw_column_name.underscore == 'facilities'
        result['general'] |= amenities_value.map { |value| value.underscore.humanize.downcase.strip }
      elsif raw_column_name.underscore == 'amenities' && amenities_value.is_a?(Array)
        result['room'] |= amenities_value.map { |value| value.underscore.humanize.downcase.strip }
      else
        result = amenities_value
      end

      result
    end

    def merge_description(merging_row_description, raw_row_description, _)
      merging_string = merging_row_description.to_s
      raw_string = raw_row_description.to_s
      longer_description = merging_string.size > raw_string.size ? merging_string : raw_string
      longer_description
    end

    def merge_images(merging_image_hash, raw_images_hash, _)
      normalized_images = normalize_image(raw_images_hash)

      # Merge images in the existed key
      merging_image_hash = if merging_image_hash.present?
        merging_image_hash.reduce({}) do |hash, (key, value)|
          current_image_links = value.reduce({}) do |hash, image|
            hash[image['link']] = true
            hash
          end

          if normalized_images[key].present?
            normalized_images[key].each do |image|
              value << image unless current_image_links[image['link']].present?
            end
          end

          hash[key] = value
          hash
        end
      else
        normalized_images
      end

      normalized_images.merge(merging_image_hash) # merge new keys
    end

    def normalize_image(images_hash)
      images_hash.reduce({}) do |hash, (key, images)|
        hash[key] = images.map do |image|
          link = image['link'] || image['url']
          caption = image['caption'] || image['description']
          {
            'link'=>link,
            'description'=>caption,
          }
        end

        hash
      end
    end
  end
end