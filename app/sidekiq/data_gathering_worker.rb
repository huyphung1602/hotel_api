# frozen_string_literal: true

class DataGatheringWorker
  include Sidekiq::Job

  def perform(source_type, filter_columns, query_key, job_id)
    # Dedup the job if it already existed
    if Job.any_running_job_with_query_key(source_type, query_key)
      Job.find(job_id).already_existed
      return
    end

    data = ::DataGatheringService.new(source_type: source_type, filter_columns: filter_columns, job_id: job_id).execute
    Cache.set_cache(object_type: source_type, query_key: query_key, json_data: data.to_json)
    data
  end
end
