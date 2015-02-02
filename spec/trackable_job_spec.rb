require "spec_helper"

describe TrackableJob do

  before { ActiveJob::Base.queue_adapter = :test }

 
  describe "#initialize" do
    
    let(:trackable_job) { TrackableJob.new }

    it "should create an object" do
      expect(trackable_job).to be_an_instance_of TrackableJob
    end
    it "should have a nil status" do
      expect(trackable_job.status).to be_nil
    end
  end

  describe 'queueing' do
    let(:trackable_job) { TrackableJob.new.enqueue }
    
    it "should have a job id" do
      expect(trackable_job.job_id).to_not be_blank
    end
    it "should set status to :queued" do
      expect(trackable_job.status).to eq :queued
    end
  end

  describe 'performing' do
    let(:trackable_job) { TrackableJob.perform_later }

    it "should set the status to complete" do
      expect(trackable_job.status).to eq :complete
    end
  end
end
