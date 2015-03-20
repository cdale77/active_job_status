module ActiveJobStatus
  class JobBatch

    attr_reader :batch_id
    attr_reader :job_ids
    attr_reader :expire_in

    def initialize(batch_id:, job_ids:, expire_in: 259200)
      @batch_id = batch_id
      @job_ids = job_ids
      @expire_in = expire_in
      ActiveJobStatus.store.delete(@batch_id) # delete any old batches
      if ActiveJobStatus.store.class.to_s == "ActiveSupport::Cache::RedisStore"
        ActiveJobStatus.store.sadd(@batch_id, job_ids)
        ActiveJobStatus.store.expire(@batch_id, expire_in)
      else
        ActiveJobStatus.store.write(@batch_id, job_ids, expires_in: expire_in)
      end
    end

    def add_jobs(job_ids:)
      @job_ids = @job_ids + job_ids
      if ActiveJobStatus.store.class.to_s == "ActiveSupport::Cache::RedisStore"
        # Save an extra redis query and perform atomic operation
        ActiveJobStatus.store.sadd(@batch_id, job_ids)
      else
        existing_job_ids = ActiveJobStatus.store.fetch(@batch_id)
        ActiveJobStatus.store.write(@batch_id, existing_job_ids.to_a | job_ids)
      end
    end

    def completed?
      job_statuses = []
      @job_ids.each do |job_id|
        job_statuses << ActiveJobStatus::JobStatus.get_status(job_id: job_id)
      end
      !job_statuses.any?
    end

    def self.find(batch_id:)
      if ActiveJobStatus.store.class.to_s == "ActiveSupport::Cache::RedisStore"
        ActiveJobStatus.store.smembers(batch_id)
      else
        ActiveJobStatus.store.fetch(batch_id).to_a
      end
    end

    private
    def write(key, job_ids, expire_in=nil)
    end
  end
end

