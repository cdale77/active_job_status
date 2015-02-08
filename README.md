[![Code Climate](https://codeclimate.com/github/cdale77/active_job_status/badges/gpa.svg)](https://codeclimate.com/github/cdale77/active_job_status)
[![Test Coverage](https://codeclimate.com/github/cdale77/active_job_status/badges/coverage.svg)](https://codeclimate.com/github/cdale77/active_job_status)
[![Build Status](https://travis-ci.org/cdale77/active_job_status.svg?branch=master)](https://travis-ci.org/cdale77/active_job_status)

# ActiveJobStatus

Uses Redis to provide simple job status information for ActiveJob. This is a
work in progress! Version 0.1.0 will probably be the first usable version. Until
then please expect frequent breaking changes, chaos, etc (Jan. 2015).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_job_status'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_job_status

## Usage

Have your jobs descend from TrackableJob instead of ActiveJob::Base

    class MyJob < TrackableJob
    end

Check the status of a job using the ActiveJob job_id

    my_job = MyJob.perform_later
    ActiveJobStatus::JobStatus.get_status(job_id: my_job.job_id)
    # => :queued, :working, :complete

Create job batches You an use any key you want (for example, you might use a 
primary key or UUID from your database). If another batch with the same key
exists, its jobs will be overwritten with the supplied list.

    my_key = "230923asdlkj230923"
    my_jobs = [my_first_job.job_id, my_second_job.job_id]
    my_batch = ActiveJobStatus::JobBatch.new(batch_key: my_key, job_ids: my_jobs)

Batches expire after 72 hours (259200 seconds).
You can change that by passing the initalizer an integer value (in seconds).

    my_key = "230923asdlkj230923"
    my_jobs = [my_first_job.job_id, my_second_job.job_id]
    my_batch = ActiveJobStatus::JobBatch.new(batch_key: my_key,
                                             job_ids: my_jobs,
                                             expire_in: 500000)

You can easily add jobs to the batch.

    new_jobs = [some_new_job.job_id, another_new_job.job_id]
    my_batch.add_jobs(job_ids: new_jobs)

And you can ask the batch if all the jobs are completed or not.

    my_batch.completed?
    # => true, false

You can ask the batch for other bits of information.

    batch.batch_key
    # => "230923asdlkj230923"
    batch.job_ids
    # => ["b67af7a0-3ed2-4661-a2d5-ff6b6a254886", "6c0216b9-ea0c-4ee9-a3b2-501faa919a66"]
    batch.expire_in
    # => 259200

## Contributing

1. Fork it ( https://github.com/[my-github-username]/active_job_status/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
