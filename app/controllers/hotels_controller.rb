require 'net/http'
require 'uri'

class HotelsController < ApplicationController
  def index
    response = get_basic_uri
    render json: response
  end

  private

  def get_basic_uri
    uri = URI('http://www.mocky.io/v2/5ebbea002e000054009f3ffc')
    Net::HTTP.get(uri)
  end
end
