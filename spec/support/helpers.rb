module Helpers
  def new_store
    if defined? ActiveSupport::Cache::RedisStore
      puts "Using RedisStore"
      ActiveSupport::Cache::RedisStore.new
    elsif defined? ActiveSupport::Cache::ReadthisStore
      puts "Using ReadthisStore"
      ActiveSupport::Cache::ReadthisStore.new
    else
      puts "Using MemoryStore"
      ActiveSupport::Cache::MemoryStore.new
    end
  end
end
