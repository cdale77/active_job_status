require "active_job"
class ActiveJobStatus::TrackableJob < ActiveJob::Base

  before_enqueue { ActiveJobStatus::JobTracker.enqueue(job_id: @job_id) }

  before_perform { ActiveJobStatus::JobTracker.update(job_id: @job_id, status: :working) }

  after_perform { ActiveJobStatus::JobTracker.remove(job_id: @job_id) }
end


