require "spec_helper"

describe ActiveJobStatus::JobStatus do
  let(:job_status) { described_class.new(status) }

  context 'when queued' do
    let(:status) { 'queued' }

    it 'returns the correct state' do
      expect(job_status.queued?).to eq true
      expect(job_status.working?).to eq false
      expect(job_status.completed?).to eq false
      expect(job_status.status).to eq :queued
    end
  end

  context 'when working' do
    let(:status) { 'working' }

    it 'returns the correct state' do
      expect(job_status.queued?).to eq false
      expect(job_status.working?).to eq true
      expect(job_status.completed?).to eq false
      expect(job_status.status).to eq :working
    end
  end

  context 'when completed' do
    let(:status) { 'completed' }

    it 'returns the correct state' do
      expect(job_status.queued?).to eq false
      expect(job_status.working?).to eq false
      expect(job_status.completed?).to eq true
      expect(job_status.status).to eq :completed
    end
  end

  context 'when nil' do
    let(:status) { nil }

    it 'returns the correct state' do
      expect(job_status.queued?).to eq false
      expect(job_status.working?).to eq false
      expect(job_status.completed?).to eq true
      expect(job_status.status).to eq nil
    end
  end
end
