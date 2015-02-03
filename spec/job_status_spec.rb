require "spec_helper"

describe ActiveJobStatus::JobStatus do

  describe "::get_status" do

    describe "for a queued job" do
      let(:job) { TrackableJob.new.enqueue }

      it "should return :queued" do
        expect(ActiveJobStatus::JobStatus.get_status(job.job_id)).to eq :queued
      end
    end

    describe "for a working job" do
      it "should return :working" do

      end
    end

    describe "for a complete job" do
      let(:job) { TrackableJob.perform_later }

      it "should return :complete" do
        expect(ActiveJobStatus::JobStatus.get_status(job.job_id)).to eq :complete
      end
    end

  end
end

