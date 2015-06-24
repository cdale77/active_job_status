require 'bundler'

Bundler.require(:default, :development)

CodeClimate::TestReporter.start
Dir["#{__dir__}/support/*.rb"].each {|file| require file }

include ActiveJob::TestHelper

ActiveJob::Base.queue_adapter = :test

RSpec.configure do |c|
  c.include Helpers
end

if defined? ActiveSupport::Cache::RedisStore
  require "active_job_status/redis"
end
