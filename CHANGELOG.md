# ActiveJobStatus
## 1.2.0
- Add support for Rails 5
- Adds many small improvements (see https://github.com/cdale77/active_job_status/pull/15)

## 1.1.0
- Add support for Redis via the Readthis gem

## 1.0.0
- Move TrackableJob inside ActiveJobStatus namespace. Bump version to 1.0.0, as
  this may be a breaking change for some users. 

## 0.0.5
- Use ActiveSupport::Cache instead of Redis, reducing dependencies. Changes
  from Gabe Kopley.

## 0.0.4
- Change name of JobStatus::get_status argument batch_key to be batch_id
- Add changelog
