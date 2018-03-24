module ActiveJobStatus
  class JobBatch

    attr_reader :batch_id
    attr_reader :job_ids

    def initialize(batch_id:, job_ids:, expire_in: 259200, store_data: true)
      @batch_id = batch_id
      @job_ids = job_ids

      @remaining_jobs_key = ActiveJobStatus::JobTracker.remaining_jobs_key(batch_id)

      # the store_data flag is used by the ::find method return a JobBatch
      # object without re-saving the data
      self.store_data(expire_in: expire_in) if store_data
    end

    def store_data(expire_in:)
      ActiveJobStatus.store.delete(@batch_id) # delete any old batches
      ActiveJobStatus.store.delete(@remaining_jobs_key)

      if ["ActiveSupport::Cache::RedisStore", "ActiveSupport::Cache::ReadthisStore"].include? ActiveJobStatus.store.class.to_s
        ActiveJobStatus.store.sadd(@batch_id, @job_ids)
        ActiveJobStatus.store.expire(@batch_id, expire_in)
      else
        ActiveJobStatus.store.write(@batch_id, @job_ids, expires_in: expire_in)
      end

      ActiveJobStatus.store.write(@remaining_jobs_key, @job_ids.size, raw: true, expires_in: expire_in)

      @job_ids.each do |job_id|
        ActiveJobStatus.store.write(["batch_for", job_id].join(":"), @batch_id, expires_in: expire_in)
      end
    end

    def add_jobs(job_ids:)
      @job_ids = @job_ids + job_ids
      if ["ActiveSupport::Cache::RedisStore", "ActiveSupport::Cache::ReadthisStore"].include? ActiveJobStatus.store.class.to_s
        # Save an extra redis query and perform atomic operation
        ActiveJobStatus.store.sadd(@batch_id, job_ids)
      else
        existing_job_ids = ActiveJobStatus.store.fetch(@batch_id)
        ActiveJobStatus.store.write(@batch_id, existing_job_ids.to_a | job_ids)
      end

      ActiveJobStatus.store.increment(@remaining_jobs_key, job_ids.size)
    end

    def completed?
      ActiveJobStatus.store.read(@remaining_jobs_key, raw: true).to_i == 0
    end

    def self.find(batch_id:)
      if ["ActiveSupport::Cache::RedisStore", "ActiveSupport::Cache::ReadthisStore"].include? ActiveJobStatus.store.class.to_s
        job_ids = ActiveJobStatus.store.smembers(batch_id)
      else
        job_ids = ActiveJobStatus.store.fetch(batch_id).to_a
      end

      if job_ids.any?
        ActiveJobStatus::JobBatch.new(batch_id: batch_id,
                                      job_ids: job_ids,
                                      store_data: false)
      end
    end

    private


    def write(key, job_ids, expire_in=nil)
    end
  end
end
