require "spec_helper"

describe ActiveJobStatus::TrackableJob do

  describe "#initialize" do

    let(:trackable_job) { ActiveJobStatus::TrackableJob.new }

    it "should create an object" do
      expect(trackable_job).to be_an_instance_of ActiveJobStatus::TrackableJob
    end
  end

  describe 'queueing' do
    let(:trackable_job) { ActiveJobStatus::TrackableJob.new.enqueue }

    it "should have a job id" do
      expect(trackable_job.job_id).to_not be_blank
    end
  end
end
