module ActiveJobStatus
  module Redis
    def sadd(key, elements)
      instrument(:sadd, key, elements: elements) do
        @data.sadd key, elements
      end
    end

    def smembers(key)
      instrument(:smembers, key) do
        @data.smembers key
      end
    end
  end
end

if defined? ActiveSupport::Cache::RedisStore
  ActiveSupport::Cache::RedisStore.include(
    ActiveJobStatus::Redis
  )
elsif defined? ActiveSupport::Cache::ReadthisStore
  ActiveSupport::Cache::ReadthisStore.include(
    ActiveJobStatus::Redis
  )
end