# frozen_string_literal: true

class RedisCache
  def self.redis
    @redis ||= Redis.new(url: (ENV['REDIS_URL'] || 'redis://127.0.0.1:6379'))
  end
end
