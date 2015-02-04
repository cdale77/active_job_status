require "spec_helper"

describe ActiveJobStatus::JobBatch do

  let(:batch) { ActiveJobStatus::JobBatch.new }

  describe "#initialize" do
    it "should create an object" do
      expect(batch).to be_an_instance_of ActiveJobStatus::JobBatch
    end
  end

end
