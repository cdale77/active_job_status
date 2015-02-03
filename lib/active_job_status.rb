require "active_job_status/trackable_job"
require "active_job_status/job_tracker"
require "active_job_status/job_status"
require "active_job_status/version"
require "mock_redis"

module ActiveJobStatus

  @@redis = MockRedis.new #default to MockRedis unless the user supplies a connection

  def self.configure_redis(redis)
    @@redis = redis
  end

  def self.redis
    @@redis
  end

end
