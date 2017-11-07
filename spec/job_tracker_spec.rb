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

    context 'with default expiration period' do
      before { ActiveJobStatus.expiration = nil }

      it 'expires in 72 hours' do
        expect(store).to receive(:write).with(job_id, "queued", expires_in: 72.hours)
        tracker.enqueued
      end
    end

    context 'with default expiration period' do
      before { ActiveJobStatus.expiration = 10.seconds }

      it 'expires in the given period' do
        expect(store).to receive(:write).with(job_id, "queued", expires_in: 10.seconds)
        tracker.enqueued
      end
    end
  end

  describe "#performing" do
    it "updates the job status" do
      tracker.performing
      expect(store.fetch(job_id)).to eq "working"
    end
  end

  describe "#completed" do
    it "updates the job status" do
      tracker.completed
      expect(store.fetch(job_id)).to eq "completed"
    end
  end

  describe "#failed" do
    it "updates the job status" do
      tracker.failed
      expect(store.fetch(job_id)).to eq "failed"
    end
  end

  describe "#deleted" do
    it "removes the job from the store" do
      tracker.deleted
      expect(store.fetch(job_id)).to eq nil
    end
  end
end
