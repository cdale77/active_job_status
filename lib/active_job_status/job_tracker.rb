module ActiveJobStatus
  class JobTracker
    DEFAULT_EXPIRATION = 72.hours.freeze

    def initialize(job_id:, store: ActiveJobStatus.store, expiration: ActiveJobStatus.expiration)
      @job_id = job_id
      @store = store
      @expiration = expiration
    end

    def enqueued
      store.write(
        job_id,
        JobStatus::ENQUEUED.to_s,
        expires_in: expiration || DEFAULT_EXPIRATION
      )
    end

    def performing
      store.write(
        job_id,
        JobStatus::WORKING.to_s
      )
    end

    def completed
      store.write(
        job_id,
        JobStatus::COMPLETED.to_s
      )
    end

    def failed
      store.write(
        job_id,
        JobStatus::FAILED.to_s
      )
    end

    def deleted
      store.delete(job_id)
    end

    private

    attr_reader :job_id, :store, :expiration
  end
end
