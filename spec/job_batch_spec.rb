require "spec_helper"

describe ActiveJobStatus::JobBatch do

  let!(:batch_key) { "mykey" }

  let!(:redis) { ActiveJobStatus.redis }

  let!(:job1) { TrackableJob.perform_later }
  let!(:job2) { TrackableJob.perform_later }
  let!(:job3) { TrackableJob.perform_later }
  let!(:job4) { TrackableJob.perform_later }

  let!(:batch) { ActiveJobStatus::JobBatch.new(batch_key: batch_key, 
                                              job_ids: [job1.job_id, job2.job_id]) }

  let!(:job_id_array) { [job1.job_id, job2.job_id, job3.job_id, job4.job_id] }

  describe "#initialize" do
    it "should create an object" do
      expect(batch).to be_an_instance_of ActiveJobStatus::JobBatch
    end
    it "should create a redis set" do
      [job1.job_id, job2.job_id].each do |job_id|
        expect(redis.smembers(batch_key)).to include job_id
      end
    end
  end

  describe "#add_jobs" do
    it "should add jobs to the set" do
      batch.add_jobs(job_ids: [job3.job_id, job4.job_id])
      job_id_array.each do |job_id|
        expect(redis.smembers(batch_key)).to include job_id
      end
    end
  end

  describe "#completed?" do
    it "should be false when jobs are queued" do
      update_redis(id_array: job_id_array, job_status: :queued)
      expect(batch.completed?).to be_falsey
    end
    it "should be false when jobs are working" do
      update_redis(id_array: job_id_array, job_status: :working)
      expect(batch.completed?).to be_falsey
    end
    it "should be true when jobs are completed" do
      clear_redis(id_array: job_id_array)
      expect(batch.completed?).to be_truthy
    end
  end

  ##### HELPERS

  def update_redis(id_array: [], job_status: :queued)
    id_array.each do |id|
      redis.set(id, job_status.to_s)
    end
  end

  def clear_redis(id_array: [])
    id_array.each do |id|
      redis.del(id)
    end
  end
end

