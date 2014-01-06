class RedisAdapter < InMemoryAdapter
  class RedisMapper
    attr_reader :klass, :redis

    def initialize(klass, redis)
      @klass, @redis = klass, redis
    end

    def []=(id, obj)
      map = read
      map[id] = obj

      write map
    end

    def [](id)
      read.fetch id
    end

    def values
      read.values
    end

    def delete(id)
      map = read
      map.delete id
      write map
    end

    def count
      read.count
    end

    private
    def read
      value = redis.get(key)
      value ? Marshal.load(value) : { }
    end

    def write(map)
      redis.set key, Marshal.dump(map)
    end

    def key
      klass.to_s
    end
  end

  def initialize
    @redis = Redis.new
  end

  def clear
    redis.flushall
  end

  def map_for_class(klass)
    RedisMapper.new klass, redis
  end

  private
  def redis
    @redis
  end
end
