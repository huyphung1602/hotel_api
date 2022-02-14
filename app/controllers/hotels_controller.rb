class HotelsController < ApplicationController
  def index
    query_key = build_query_key(hotel_filter)
    lasted_cached_data = Cache.retrive_lasted_cache(object_type: 'HotelJson', query_key: query_key)

    hotels = if lasted_cached_data.present?
      JSON.parse(lasted_cached_data)
    else
      raw_hotels = ::DataFetchingService.fetch_data('hotels')
      merged_hotels = ::DataMergingService.merge_data_structure(::HotelMerger, raw_hotels, hotel_filter)
      Cache.set_cache(object_type: 'HotelJson', query_key: query_key, json_data: merged_hotels.to_json)
      merged_hotels
    end

    render json: hotels
  rescue => e
    render json: { error: e }, status: 400
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
