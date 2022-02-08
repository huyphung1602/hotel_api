class HotelsController < ApplicationController
  def index
    hotels = ::DataFetcherService.fetch_data('hotels')
    render json: hotels
  end
end
