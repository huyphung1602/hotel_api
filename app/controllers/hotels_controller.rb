# frozen_string_literal: true

class HotelsController < ApplicationController
  def index
    job = Job.create(source_type: 'hotel_json', query_key: query_key)
    hotels = DataGatheringWorker.may_be_async('hotel_json', filter_columns, query_key, job.id)
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
