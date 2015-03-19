module ActiveJobStatus
  module JobTracker
    # Provides methods to CRUD job status records in Redis

    def self.enqueue(job_id:)
      ActiveJobStatus.store.write(job_id, "queued", expires_in: 259200)
    end

    def self.update(job_id:, status:)
      ActiveJobStatus.store.write(job_id, status.to_s)
    end

    def self.remove(job_id:)
      ActiveJobStatus.store.delete(job_id)
    end
  end
end
