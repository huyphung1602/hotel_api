# frozen_string_literal: true

class Cache < ApplicationRecord
  validates :object_type, presence: true
  validates :query_key, presence: true

  def self.set_cache(object_type:, query_key:, json_data:)
    ActiveRecord::Base.transaction do
      RedisCache.redis.set(query_key, json_data)
      Cache.create(object_type: object_type, query_key: query_key)
    # We log the error because caching the data is should not raise error that block the main procedure (which is return the data)
    rescue StandardError => e
      Rails.logger.error "Fail to set cach for #{object_type} with #{query_key}"
      Rails.logger.error e.inspect
    end
  end

  def self.retrive_lasted_cache(object_type:, query_key:)
    cache_key = Cache.where(object_type: object_type, query_key: query_key).order(created_at: :desc).first&.query_key
    cache_key.present? ? RedisCache.redis.get(query_key) : nil

  # We log the error because getting the data from cache should not raise error that block the main procedure (which is return the data)
  rescue StandardError => e
    Rails.logger.error "Fail to get data from cache for #{object_type} with #{query_key}"
    Rails.logger.error e.inspect
    nil
  end

  def self.generate_query_key(filter_columns)
    return 'full' unless filter_columns.present?

    filter_columns.map do |column_name, filter_values|
      "#{column_name}_#{filter_values.sort.join('_')}"
    end.join('_')
  end
end
