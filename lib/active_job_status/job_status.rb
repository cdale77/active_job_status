module ActiveJobStatus
  module JobStatus
    # Provides a way to check on the status of a given job

    def self.get_status(job_id:)
      status = ActiveJobStatus.redis.get(job_id)
      status ? status.to_sym : nil
    end
  end
end

