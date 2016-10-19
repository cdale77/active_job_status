require "spec_helper"

describe ActiveJobStatus::JobBatch do

  let!(:batch_id) { Time.now }

  let!(:store) { ActiveJobStatus.store = new_store }

  let!(:job1) { ActiveJobStatus::TrackableJob.perform_later }
  let!(:job2) { ActiveJobStatus::TrackableJob.perform_later }
  let!(:job3) { ActiveJobStatus::TrackableJob.perform_later }
  let!(:job4) { ActiveJobStatus::TrackableJob.perform_later }

  let!(:first_jobs) { [job1.job_id, job2.job_id] }
  let!(:addl_jobs) { [job3.job_id, job4.job_id] }
  let!(:total_jobs) { first_jobs + addl_jobs }

  let!(:batch) { ActiveJobStatus::JobBatch.new(batch_id: batch_id,
                                              job_ids: first_jobs) }


  describe "#initialize" do
    it "should create an object" do
      expect(batch).to be_an_instance_of ActiveJobStatus::JobBatch
    end
    it "should write to the cache store" do
      expect(
        ActiveJobStatus::JobBatch.find(batch_id: batch_id).job_ids
      ).to match_array(first_jobs)
    end
  end

  describe "#job_ids" do
    describe "when jobs are present" do
      it "should return an array of job ids" do
        expect(batch.job_ids).to match_array(first_jobs)
      end
    end
  end

  describe "#add_jobs" do
    it "should add jobs to the set" do
      batch.add_jobs(job_ids: addl_jobs)
      total_jobs.each do |job_id|
        expect(ActiveJobStatus::JobBatch.find(batch_id: batch_id).job_ids).to \
          include job_id
      end
    end
  end

  describe "#completed?" do
    it "should be false when jobs are queued" do
      update_store(id_array: total_jobs, job_status: :queued)
      expect(batch.completed?).to be_falsey
    end
    it "should be false when jobs are working" do
      update_store(id_array: total_jobs, job_status: :working)
      expect(batch.completed?).to be_falsey
    end
    it "should be false with mixed jobs status of working and completed" do
      update_store_mixed_status(id_array: total_jobs, 
                                job_status_array: [:working, :completed])
      expect(batch.completed?).to be_falsey
    end
    it "should be true when jobs are all completed" do
      update_store(id_array: total_jobs, job_status: :completed)
      expect(batch.completed?).to be_truthy
    end
    it "should be true when jobs are not in the store" do
      clear_store(id_array: total_jobs)
      expect(batch.completed?).to be_truthy
    end
  end

  describe "::find" do
    describe "when a batch is present" do
      it "should return a JobBatch object" do
        expect(ActiveJobStatus::JobBatch.find(batch_id: batch_id)).to \
          be_an_instance_of ActiveJobStatus::JobBatch
      end
    end

    describe "when no batch is present" do
      it "should return nil" do
        expect(ActiveJobStatus::JobBatch.find(batch_id: "baz")).to be_nil
      end
    end
  end

  describe "expiring job" do
    it "should allow the expiration time to be set in seconds" do
      expect(ActiveJobStatus::JobBatch.new(batch_id: "newkey",
                                            job_ids: first_jobs,
                                            expire_in: 200000)).to \
            be_an_instance_of ActiveJobStatus::JobBatch
    end
    it "should expire" do
      ActiveJobStatus::JobBatch.new(batch_id: "expiry",
                                    job_ids: first_jobs,
                                    expire_in: 1)
      travel(2.seconds) do
        expect(
          ActiveJobStatus::JobBatch.find(batch_id: "expiry")
        ).to be_nil
      end
    end
  end

  ##### HELPERS

  def update_store(id_array: [], job_status: :queued)
    id_array.each do |id|
      store.write(id, job_status.to_s)
    end
  end

  def update_store_mixed_status(id_array: [], job_status_array: [:queued])
    n_element = job_status_array.count
    id_array.each_with_index do |id, index|
      store.write(id, job_status_array[index % n_element].to_s)
    end
  end

  def clear_store(id_array: [])
    id_array.each do |id|
      store.delete(id)
    end
  end
end
