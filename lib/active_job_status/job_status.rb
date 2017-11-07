module ActiveJobStatus
  class JobStatus
    ENQUEUED  = :queued
    WORKING   = :working
    COMPLETED = :completed
    FAILED    = :failed

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
      status == COMPLETED
    end

    def failed?
      status == FAILED
    end

    def empty?
      status.nil?
    end
  end
end
