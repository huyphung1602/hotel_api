# frozen_string_literal: true

class ApplicationController < ActionController::API
  private

  def query_key
    return 'full' unless filter_columns.present?

    filter_columns.map do |k, v|
      "#{k}_#{v.sort.join('_')}"
    end.join('_')
  end
end
