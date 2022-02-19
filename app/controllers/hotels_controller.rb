class HotelsController < ApplicationController
  def index
    hotel_filter = hotel_filter_service.generate_filter
    query_key = hotel_filter_service.generate_query_key
    lasted_cached_data = Cache.retrive_lasted_cache(object_type: 'hotel_json', query_key: query_key)

    hotels = if lasted_cached_data.present?
      SourceGatheringWorkerJob.perform_async('hotel_json', hotel_filter, query_key)
      JSON.parse(lasted_cached_data)
    else
      merged_hotels = ::DataGatheringService.execute(source_type: 'hotel_json', filter: hotel_filter)
      Cache.set_cache(object_type: 'hotel_json', query_key: query_key, json_data: merged_hotels.to_json)
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

  def hotel_filter_service
    column_name, values = if hotel_ids.present?
      values = params[:hotels].is_a?(Array) ? params[:hotels] : [params[:hotels]]
      ['hotel_id', values]
    elsif destination_ids.present?
      values = params[:destinations].is_a?(Array) ? params[:destinations] : [params[:destinations]]
      ['destination_id', values]
    end

    FilterBuildingService.new(column_name, values)
  end
end
