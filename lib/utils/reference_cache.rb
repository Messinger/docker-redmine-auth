class ReferenceCache
  REDIS_CACHE_PREFIX='dockerauth:'

  CACHE_DURATION = if Setting.respond_to?(:references_cache_duration)
                     Setting.references_cache_duration || 600
                   else
                     600
                   end

  def intialize _duration=nil
    @duration = _duration
  end

  def duration
    @duration||CACHE_DURATION
  end

  class << self

    def cache_expired?(key)
      $redis.get("#{REDIS_MUTEX_CACHE_PREFIX}#{key}").nil?
    end

    def update_cache(key, value)
      $redis.set("#{REDIS_MUTEX_CACHE_PREFIX}#{key}", Marshal::dump(value))
      $redis.expire("#{REDIS_MUTEX_CACHE_PREFIX}#{key}", duration)
      value
    end

    def get_cached(key)
      _v = $redis.get("#{REDIS_MUTEX_CACHE_PREFIX}#{key}")
      Marshal::load(_v) unless _v.nil?
    end

  end

end
