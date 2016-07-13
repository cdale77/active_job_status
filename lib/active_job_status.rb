require "active_job_status/hooks"
require "active_job_status/trackable_job"
require "active_job_status/job_tracker"
require "active_job_status/job_status"
require "active_job_status/job_batch"
require "active_job_status/version"
require "active_job_status/configure_redis" if defined? Rails

module ActiveJobStatus
  class << self
    attr_accessor :store
  end
end
