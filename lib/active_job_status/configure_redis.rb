require 'rails'
class ConfigureRedis < Rails::Railtie
  initializer "configure_redis.configure_rails_initializers" do
    if defined? ActiveSupport::Cache::RedisStore || defined? ActiveSupport::Cache::ReadthisStore
      require "active_job_status/redis"
    end
  end
end
