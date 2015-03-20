module ActiveSupportExtensions
  module Cache
    module RedisStore
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
end

if defined? ActiveSupport::Cache::RedisStore
  ActiveSupport::Cache::RedisStore.include(
    ActiveSupportExtensions::Cache::RedisStore
  )
end

