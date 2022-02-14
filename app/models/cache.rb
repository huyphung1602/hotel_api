class Cache < ApplicationRecord
  def self.set_cache(object_type:, query_key:, json_data:)
    $redis_cache.set(query_key, json_data)
    Cache.create!(object_type: object_type, query_key: query_key)
  end

  def self.retrive_lasted_cache(object_type:, query_key:)
    cache_key = Cache.where(object_type: object_type, query_key: query_key).order(created_at: :desc).first&.query_key
    data = if cache_key.present?
      $redis_cache.get(query_key)
    else
      nil
    end

    data
  end
end
