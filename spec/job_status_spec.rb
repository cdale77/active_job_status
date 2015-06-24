require "spec_helper"
describe ActiveJobStatus::JobStatus do

  describe "::get_status" do

    describe "for a queued job" do
      let(:job) { TrackableJob.new.enqueue }

      it "should return :queued" do
        expect(ActiveJobStatus::JobStatus.get_status(job_id: job.job_id)).to eq :queued
      end
    end

    describe "for a complete job" do

      let!(:job) { TestJob.new('foo').enqueue }
      it "should return :complete after the job runs" do
        job.perform_now
        expect(ActiveJobStatus::JobStatus.get_status(job_id: job.job_id)).to be_nil
      end
    end
  end
end

