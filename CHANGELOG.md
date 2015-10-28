# ActiveJobStatus

## 1.0.0
- Move TrackableJob inside ActiveJobStatus namespace. Bump version to 1.0.0, as
  this may be a breaking change for some users. 

## 0.0.5
- Use ActiveSupport::Cache instead of Redis, reducing dependencies. Changes
  from Gabe Kopley.

## 0.0.4
- Change name of JobStatus::get_status argument batch_key to be batch_id
- Add changelog
