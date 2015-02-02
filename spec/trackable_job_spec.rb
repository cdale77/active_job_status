require "spec_helper"

describe TrackableJob do

  let(:trackable_job) { TrackableJob.new }

  describe "#initialize" do
    it "should create an object" do
      expect(trackable_job).to be_an_instance_of TrackableJob
    end
  end

end
