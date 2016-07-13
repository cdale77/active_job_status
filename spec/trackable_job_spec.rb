require "spec_helper"

describe ActiveJobStatus::TrackableJob do
  class DummyJob < ActiveJobStatus::TrackableJob
    def perform; end;
  end

  let(:job) { DummyJob.new }

  describe 'queueing' do
    it "should have a job id" do
      expect(job.job_id).to_not be_blank
    end
  end

  describe 'tracking hooks' do
    let(:job_tracker) { instance_double(ActiveJobStatus::JobTracker) }

    before do
      allow(job).to receive(:job_id) { 'j0b-1d' }
    end

    describe 'before enqueue' do
      it 'starts to track the job with JobTracker' do
        expect(ActiveJobStatus::JobTracker).to receive(:new).with(job_id: 'j0b-1d') { job_tracker }
        expect(job_tracker).to receive(:enqueued)
        job.enqueue
      end
    end

    describe 'before/after perform' do
      it 'updates the job status with JobTracker and then remove it' do
        expect(ActiveJobStatus::JobTracker).to receive(:new).with(job_id: 'j0b-1d') { job_tracker }
        expect(job_tracker).to receive(:performing)
        expect(job_tracker).to receive(:completed)
        job.perform_now
      end
    end
  end
end
