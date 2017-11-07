module ActiveJobStatus
  module Hooks
    def self.included(base)
      base.class_eval do

        around_enqueue do |job, block|
          begin
            before_enqueue(job)
            job_tracker.enqueued
            block.call
            on_enqueue_success(job)
          rescue StandardError => exception
            job_tracker.failed
            on_enqueue_failure(exception, job)
            raise exception
          end
        end

        around_perform do |job, block|
          begin
            before_perform(job)
            job_tracker.performing
            block.call
            job_tracker.completed
            on_perform_success(job)
          rescue StandardError => exception
            job_tracker.failed
            on_perform_failure(exception, job)
            raise exception
          end
        end

      end

      def before_enqueue(job)
      end

      def on_enqueue_failure(exception, job)
      end

      def on_enqueue_success(job)
      end

      def before_perform(job)
      end

      def on_perform_failure(exception, job)
      end

      def on_perform_success(job)
      end

    end

    private

    def job_tracker
      @job_tracker ||= ActiveJobStatus::JobTracker.new(job_id: job_id)
    end
  end
end
