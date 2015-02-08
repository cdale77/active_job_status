module ActiveJobStatus
  module JobTracker
    # Provides methods to CRUD job status records in Redis
    require "redis"

    def self.enqueue(job_id:)
      ActiveJobStatus.redis.set(job_id, "queued")
      ActiveJobStatus.redis.expire(job_id, 259200)
    end

    def self.update(job_id:, status:)
      ActiveJobStatus.redis.set(job_id, status.to_s)
    end

    def self.remove(job_id:)
      ActiveJobStatus.redis.del(job_id)
    end
  end
end
