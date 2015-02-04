require "spec_helper"

describe ActiveJobStatus::JobStatus do

  describe "::get_status" do

    describe "for a queued job" do
      let(:job) { TrackableJob.new.enqueue }

      it "should return :queued" do
        expect(ActiveJobStatus::JobStatus.get_status(job_id: job.job_id)).to eq :queued
      end
    end

    describe "for a working job" do
      it "should return :working", pending: true do

      end
    end

    describe "for a complete job" do

      let!(:job) { TrackableJob.perform_later }
      sleep(10)
      #clear_performed_jobs
      it "should return :complete", pending: true do
        expect(ActiveJobStatus::JobStatus.get_status(job_id: job.job_id)).to be_nil
      end
    end
  end
end

