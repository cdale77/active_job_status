require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
require "active_job_status"
include ActiveJob::TestHelper
require "active_support/testing/time_helpers"
include ActiveSupport::Testing::TimeHelpers
ActiveJob::Base.queue_adapter = :test
