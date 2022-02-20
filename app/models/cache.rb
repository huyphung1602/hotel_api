class Cache < ApplicationRecord
  validates :object_type, presence: true
  validates :query_key, presence: true

  def self.set_cache(object_type:, query_key:, json_data:)
    ActiveRecord::Base.transaction do
      $redis_cache.set(query_key, json_data)
      Cache.create(object_type: object_type, query_key: query_key)
    # We log the error because caching the data is should not raise error that block the main procedure (which is return the data)
    rescue => e
      Rails.logger.error "Fail to set cach for #{object_type} with #{query_key}"
      Rails.logger.error e.inspect
    end
  end

  def self.retrive_lasted_cache(object_type:, query_key:)
    cache_key = Cache.where(object_type: object_type, query_key: query_key).order(created_at: :desc).first&.query_key
    data = if cache_key.present?
      $redis_cache.get(query_key)
    else
      nil
    end

    data

  # We log the error because getting the data from cache should not raise error that block the main procedure (which is return the data)
  rescue => e
    Rails.logger.error "Fail to get data from cache for #{object_type} with #{query_key}"
    Rails.logger.error e.inspect
    nil
  end
end
