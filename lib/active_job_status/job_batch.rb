module ActiveJobStatus
  class JobBatch

    attr_reader :batch_id
    attr_reader :job_ids

    def initialize(batch_id:, job_ids:, expire_in: 259200, store_data: true)
      @batch_id = batch_id
      @job_ids = job_ids
      # the store_data flag is used by the ::find method return a JobBatch
      # object without re-saving the data
      self.store_data(expire_in: expire_in) if store_data
    end

    def store_data(expire_in:)
      ActiveJobStatus.store.delete(@batch_id) # delete any old batches
      if ["ActiveSupport::Cache::RedisStore", "ActiveSupport::Cache::ReadthisStore"].include? ActiveJobStatus.store.class.to_s
        ActiveJobStatus.store.sadd(@batch_id, @job_ids)
        ActiveJobStatus.store.expire(@batch_id, expire_in)
      else
        ActiveJobStatus.store.write(@batch_id, @job_ids, expires_in: expire_in)
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
    end

    def completed?
      !@job_ids.map do |job_id|
        job_status = ActiveJobStatus.get_status(job_id)
        job_status != nil && job_status != :completed
      end.any?
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
