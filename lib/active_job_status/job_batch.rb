module ActiveJobStatus
  class JobBatch

    attr_reader :batch_key

    def initialize(batch_key:, job_ids:, expire_in: 259200)
      @batch_key = batch_key
      @job_ids = job_ids
      ActiveJobStatus.redis.del(@batch_key) # delete any old batches
      ActiveJobStatus.redis.sadd(@batch_key, job_ids)
      ActiveJobStatus.redis.expire(@batch_key, expire_in)
    end

    def add_jobs(job_ids:)
      @job_ids = @job_ids + job_ids
      ActiveJobStatus.redis.sadd(@batch_key, job_ids)
    end

    def completed?
      job_statuses = []
      @job_ids.each do |job_id|
        job_statuses << ActiveJobStatus::JobStatus.get_status(job_id: job_id)
      end
      !job_statuses.any?
    end

    def self.find(batch_key:)
      ActiveJobStatus.redis.smembers(batch_key)
    end
  end
end

