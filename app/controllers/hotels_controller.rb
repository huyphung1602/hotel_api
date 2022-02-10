class HotelsController < ApplicationController
  def index
    raw_hotels = ::DataFetcherService.fetch_data('hotels')
    merged_hotels = ::DataMergingService.merge_data_structure(HotelMerger, raw_hotels)
    render json: merged_hotels
  end
end
