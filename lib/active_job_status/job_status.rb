module ActiveJobStatus
  module JobStatus
    ENQUEUED = 'queued'.freeze
    WORKING  = 'working'.freeze

    # Provides a way to check on the status of a given job
    def self.get_status(job_id:)
      status = ActiveJobStatus.store.fetch(job_id)
      status ? status.to_sym : nil
    end
  end
end
