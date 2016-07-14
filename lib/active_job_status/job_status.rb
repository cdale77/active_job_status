module ActiveJobStatus
  class JobStatus
    ENQUEUED  = :queued
    WORKING   = :working
    COMPLETED = :completed

    attr_reader :status

    def initialize(status)
      @status = status && status.to_sym
    end

    def queued?
      status == ENQUEUED
    end

    def working?
      status == WORKING
    end

    def completed?
      status == COMPLETED || status.nil?
    end
  end
end
