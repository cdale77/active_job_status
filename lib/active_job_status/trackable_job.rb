require "active_job"
class TrackableJob < ActiveJob::Base

  attr_reader :status

  before_enqueue do |job|
    puts "before enqueue"
    @status = :queuing
  end

  after_enqueue do |job|
    @status = :queued
  end

  before_perform do |job|
    puts "before perform"
    @status = :working
  end

  after_perform do |job|
    puts "after perform"
    @status = :complete
  end
end


