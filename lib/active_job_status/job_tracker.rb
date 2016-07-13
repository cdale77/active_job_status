module ActiveJobStatus
  class JobTracker
    EXPIRATION = 72.hours.freeze

    def initialize(job_id:, store: ActiveJobStatus.store)
      @job_id = job_id
      @store = store
    end

    def enqueued
      store.write(job_id, JobStatus::ENQUEUED, expires_in: EXPIRATION)
    end

    def performing
      store.write(job_id, JobStatus::WORKING)
    end

    def completed
      store.delete(job_id)
    end

    private

    attr_reader :job_id, :store
  end
end
