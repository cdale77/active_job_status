require "active_job_status/trackable_job"
require "active_job_status/job_tracker"
require "active_job_status/job_status"
require "active_job_status/job_batch"
require "active_job_status/version"
require "active_support_extensions/cache/redis_store"

module ActiveJobStatus
  class << self
    attr_accessor :store
  end
end

