[![Code Climate](https://codeclimate.com/github/cdale77/active_job_status/badges/gpa.svg)](https://codeclimate.com/github/cdale77/active_job_status)
[![Test Coverage](https://codeclimate.com/github/cdale77/active_job_status/badges/coverage.svg)](https://codeclimate.com/github/cdale77/active_job_status)
[![Build Status](https://travis-ci.org/cdale77/active_job_status.svg?branch=master)](https://travis-ci.org/cdale77/active_job_status)

# ActiveJobStatus

Uses Redis to provide simple job status information for ActiveJob. This is a
work in progress! (Jan. 2015).

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

Add jobs to batches. You an use any key you want (for example, you might use a 
primary key or UUID from your database).

    my_key = "230923asdlkj230923"
    my_batch = ActiveJobStatus::JobBatch.new(batch_key: my_key)

If you'd like you can pass an initial array of ActiveJob job_ids:

    my_key = "230923asdlkj230923"
    my_jobs = [my_first_job.job_id, my_second_job.job_id]
    my_batch = ActiveJobStatus::JobBatch.new(batch_key: my_key, job_ids: my_jobs)

You can easily add jobs to the batch

    new_jobs = [some_new_job.job_id, another_new_job.job_id]
    my_batch.add_jobs(job_ids: new_jobs)

And you can ask the batch if all the jobs are completed or not

    my_batch.completed?
    # => true, false


## Contributing

1. Fork it ( https://github.com/[my-github-username]/active_job_status/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
