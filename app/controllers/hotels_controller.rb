class HotelsController < ApplicationController
  def index
    raw_hotels = ::DataFetchingService.fetch_data('hotels')
    merged_hotels = ::DataMergingService.merge_data_structure(::HotelMerger, raw_hotels, hotel_filter)

    query_key = build_query_key(hotel_filter)
    puts query_key
    $redis_cache.set(query_key, merged_hotels.to_json)
    render json: merged_hotels
  end

  private

  def hotel_ids
    params[:hotels]
  end

  def destination_ids
    params[:destinations]
  end

  def hotel_filter
    column_name, values = if hotel_ids.present?
      values = params[:hotels].is_a?(Array) ? params[:hotels] : [params[:hotels]]
      ['hotel_id', values]
    elsif destination_ids.present?
      values = params[:destinations].is_a?(Array) ? params[:destinations] : [params[:destinations]]
      ['destination_id', values]
    end

    FilterBuildingService.generate_filter(column_name, values)
  end

  def build_query_key(filter)
    value_key = filter[:filter_values].keys.sort.reduce('') do |string, value|
      "#{string}_#{value.to_s}"
    end

    "#{filter[:column]}#{value_key}"
  end
end
