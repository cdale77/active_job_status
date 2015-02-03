require "active_job"
class TrackableJob < ActiveJob::Base

  before_enqueue do |job|
    puts "before enqueue"
  end

  before_perform do |job|
    puts "before perform"
  end

  after_perform do |job|
    puts "after perform"
  end
end


