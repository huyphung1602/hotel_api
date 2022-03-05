# frozen_string_literal: true

class HotelsController < ApplicationController
  def index
    filters = FilterGenerator.generate_filters(filter_columns)
    query_key = Cache.generate_query_key(filter_columns)
    lasted_cached_data = Cache.retrive_lasted_cache(object_type: 'hotel_json', query_key: query_key)
    job = Job.create(source_type: 'hotel_json', query_key: query_key)

    hotels = if lasted_cached_data.present?
               DataGatheringWorker.perform_async('hotel_json', filters, query_key, job.id)
               JSON.parse(lasted_cached_data)
             else
               DataGatheringWorker.new.perform('hotel_json', filters, query_key, job.id)
             end

    render json: hotels
  rescue StandardError => e
    render json: { error: e }, status: 400
  end

  private

  def hotel_ids
    Array.wrap(params[:hotels])
  end

  def destination_ids
    Array.wrap(params[:destinations])
  end

  def filter_columns
    filter_columns = {}
    filter_columns[:hotel_id] = hotel_ids if hotel_ids.present?
    filter_columns[:destination_id] = destination_ids if destination_ids.present?
    filter_columns
  end
end
