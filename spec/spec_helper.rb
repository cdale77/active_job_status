require 'bundler'
require "#{__dir__}/support/helpers"

Bundler.require(:default, :development)
CodeClimate::TestReporter.start

include ActiveJob::TestHelper

require "active_support/testing/time_helpers"
include ActiveSupport::Testing::TimeHelpers

ActiveJob::Base.queue_adapter = :test

RSpec.configure do |c|
  c.include Helpers
end
