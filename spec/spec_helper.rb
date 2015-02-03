require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require "active_job_status"
ActiveJob::Base.queue_adapter = :test
