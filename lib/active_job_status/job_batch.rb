module ActiveJobStatus
  class JobBatch

    attr_reader :batch_key

    def initialize(batch_key:, job_ids: [])
      @batch_key = batch_key
      @job_ids = job_ids

      add_jobs(job_ids: @job_ids)
    end

    def add_jobs(job_ids: [])
      @job_ids = @job_ids | job_ids
      ActiveJobStatus.redis.sadd(@batch_key, @job_ids)
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

