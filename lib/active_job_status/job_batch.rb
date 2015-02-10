module ActiveJobStatus
  class JobBatch

    attr_reader :batch_id
    attr_reader :job_ids
    attr_reader :expire_in

    def initialize(batch_id:, job_ids:, expire_in: 259200)
      @batch_id = batch_id
      @job_ids = job_ids
      @expire_in = expire_in
      ActiveJobStatus.redis.del(@batch_id) # delete any old batches
      ActiveJobStatus.redis.sadd(@batch_id, @job_ids)
      ActiveJobStatus.redis.expire(@batch_id, @expire_in)
    end

    def add_jobs(job_ids:)
      @job_ids = @job_ids + job_ids
      ActiveJobStatus.redis.sadd(@batch_id, job_ids)
    end

    def completed?
      job_statuses = []
      @job_ids.each do |job_id|
        job_statuses << ActiveJobStatus::JobStatus.get_status(job_id: job_id)
      end
      !job_statuses.any?
    end

    def self.find(batch_id:)
      ActiveJobStatus.redis.smembers(batch_id)
    end
  end
end

