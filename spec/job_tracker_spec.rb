require "spec_helper"

describe ActiveJobStatus::JobTracker do

  let!(:store) { ActiveJobStatus.store = new_store }
  let(:job) { TrackableJob.new.enqueue }

  describe "::enqueue" do
    it "should enqueue a job" do
      ActiveJobStatus::JobTracker.enqueue(job_id: job.job_id)
      expect(store.fetch(job.job_id)).to eq "queued"
    end
  end

  describe "::update" do
    it "should update a job status" do
      ActiveJobStatus::JobTracker.update(job_id: job.job_id, status: :working)
      expect(store.fetch(job.job_id)).to eq "working"
    end
  end

  describe "::remove" do
    it "should remove the job from the cache store" do
      ActiveJobStatus::JobTracker.remove(job_id: job.job_id)
      expect(store.fetch(job.job_id)).to eq nil
    end
  end
end

