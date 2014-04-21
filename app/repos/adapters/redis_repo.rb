class RedisRepo < MemoryRepo
  def initialize(redis = Redis.new)
    @map = ::Chassis::RedisRepo::RedisMap.new(redis)
  end
end
