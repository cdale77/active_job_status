require "active_job"
require "active_job_status/hooks"

module ActiveJobStatus
  class TrackableJob < ActiveJob::Base
    include ActiveJobStatus::Hooks
  end
end
