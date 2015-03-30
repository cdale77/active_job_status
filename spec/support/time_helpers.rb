if defined? ActiveSupport::Cache::RedisStore
  # For redis we need to sleep to test
  def travel(interval)
    sleep interval
    yield
  end
else
  require "active_support/testing/time_helpers"
  include ActiveSupport::Testing::TimeHelpers
end
