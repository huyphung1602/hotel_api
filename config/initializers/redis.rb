# frozen_string_literal: true

$redis_cache = Redis::Namespace.new 'redis-cache', redis: Redis.new
