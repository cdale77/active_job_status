require "spec_helper"

describe ActiveJobStatus::JobTracker do
  let!(:store) { ActiveJobStatus.store = new_store }
  let(:job_id) { 'j0b-1d' }
  let(:tracker) { described_class.new(job_id: job_id) }

  describe "#enqueued" do
    it "starts tracking the job" do
      tracker.enqueued
      expect(store.fetch(job_id)).to eq "queued"
    end
  end

  describe "#performing" do
    it "updates the job status" do
      tracker.performing
      expect(store.fetch(job_id)).to eq "working"
    end
  end

  describe "#completed" do
    it "removes the job from the store" do
      tracker.completed
      expect(store.fetch(job_id)).to eq nil
    end
  end
end
