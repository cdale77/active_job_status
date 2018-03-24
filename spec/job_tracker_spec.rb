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

    context 'with a batch job' do
      let(:batch_id) { '12345'}
      let(:tracker) { described_class.new(job_id: job_id, batch_id: batch_id) }
      it 'updates the batch tracking if the job was not already completed' do
        allow(store).to receive(:fetch) { "working" }
        expect(store).to receive(:decrement).with(ActiveJobStatus::JobTracker.remaining_jobs_key(batch_id))
        expect(store).to receive(:delete).with(ActiveJobStatus::JobTracker.batch_for_key(job_id))
        tracker.completed
      end
      it 'does not update the batch tracking if the job was already completed' do
        allow(store).to receive(:fetch) { "completed" }
        expect(store).not_to receive(:decrement)
        expect(store).not_to receive(:delete)
        tracker.completed
      end
      it 'does not update the batch tracking if the job does not exist' do
        allow(store).to receive(:fetch) { nil }
        expect(store).not_to receive(:decrement)
        expect(store).not_to receive(:delete)
        tracker.completed
      end
    end
  end

  describe "#deleted" do
    it "removes the job from the store" do
      tracker.deleted
      expect(store.fetch(job_id)).to eq nil
    end

    context 'with a batch job' do
      let(:batch_id) { '12345'}
      let(:tracker) { described_class.new(job_id: job_id, batch_id: batch_id) }
      it 'updates the batch tracking if the job was not already completed' do
        allow(store).to receive(:fetch) { "working" }
        expect(store).to receive(:decrement).with(ActiveJobStatus::JobTracker.remaining_jobs_key(batch_id))
        expect(store).to receive(:delete).with(ActiveJobStatus::JobTracker.batch_for_key(job_id))
        tracker.deleted
      end
      it 'does not update the batch tracking if the job was already completed, but does delete the batch_for_key' do
        allow(store).to receive(:fetch) { "completed" }
        expect(store).not_to receive(:decrement)
        expect(store).to receive(:delete).with(ActiveJobStatus::JobTracker.batch_for_key(job_id))
        tracker.deleted
      end
      it 'does not update the batch tracking if the job does not exist, but does delete the batch_for_key' do
        allow(store).to receive(:fetch) { nil }
        expect(store).not_to receive(:decrement)
        expect(store).to receive(:delete).with(ActiveJobStatus::JobTracker.batch_for_key(job_id))
        tracker.deleted
      end
    end
  end
end
