module ActiveJobStatus
  class JobTracker
    DEFAULT_EXPIRATION = 72.hours.freeze

    def self.remaining_jobs_key(batch_id)
      ["remaining_jobs", batch_id].join(":")
    end

    def self.batch_for_key(job_id)
      ["batch_for", job_id].join(":")
    end

    def initialize(job_id:, batch_id: nil, store: ActiveJobStatus.store, expiration: ActiveJobStatus.expiration)
      @job_id = job_id
      @batch_id = batch_id
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
        JobStatus::WORKING.to_s,
        expires_in: expiration || DEFAULT_EXPIRATION

      )
    end

    def completed
      store.write(
        job_id,
        JobStatus::COMPLETED.to_s,
        expires_in: expiration || DEFAULT_EXPIRATION

      )
      maybe_remove_from_batch
    end

    def deleted
      definitely_remove_from_batch
    end

    private

    def maybe_remove_from_batch
      previous_status = store.fetch(job_id)
      if batch_id && previous_status && previous_status != JobStatus::COMPLETED.to_s
        store.decrement(self.class.remaining_jobs_key(batch_id))
        store.delete(self.class.batch_for_key(job_id))
        true
      else
        false
      end
    end

    # in the case of hard deleted jobs, we want to
    # ensure we clean up the batch key for that job
    def definitely_remove_from_batch
      store.delete(self.class.batch_for_key(job_id)) unless maybe_remove_from_batch
    end

    attr_reader :job_id, :batch_id, :store, :expiration
  end
end
