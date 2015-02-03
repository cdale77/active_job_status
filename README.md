[![Code Climate](https://codeclimate.com/github/cdale77/active_job_status/badges/gpa.svg)](https://codeclimate.com/github/cdale77/active_job_status)
[![Test Coverage](https://codeclimate.com/github/cdale77/active_job_status/badges/coverage.svg)](https://codeclimate.com/github/cdale77/active_job_status)
[![Build Status](https://travis-ci.org/cdale77/active_job_status.svg?branch=master)](https://travis-ci.org/cdale77/active_job_status)

# ActiveJobStatus

Uses Redis to provide simple job status information for ActiveJob.

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

    ActiveJobStatus::JobStatus.get_status(job_id)
    # => :queued, :working, :complete

## Contributing

1. Fork it ( https://github.com/[my-github-username]/active_job_status/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
