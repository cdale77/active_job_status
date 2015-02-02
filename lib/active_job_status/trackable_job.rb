require "active_job"  
class TrackableJob < ActiveJob::Base

    before_enqueue do |job|
      puts "before"
    end

    after_perform do |job|
      puts "after"
    end
  end


