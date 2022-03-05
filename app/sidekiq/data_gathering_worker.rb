# frozen_string_literal: true

class DataGatheringWorker
  include Sidekiq::Job

  def perform(source_type, filter_columns, query_key, job_id)
    # Dedup the job if it already existed
    if Job.any_running_job_with_query_key(source_type, query_key)
      Job.find(job_id).already_existed
      return
    end

    data = ::DataGatheringService.execute(source_type, filter_columns)
    Cache.set_cache(object_type: source_type, query_key: query_key, json_data: data.to_json)
    data
  end

  def self.may_be_async(source_type, filter_columns, query_key, job_id)
    lasted_cached_data = Cache.retrive_lasted_cache(object_type: source_type, query_key: query_key)

    if lasted_cached_data.present?
      perform_async(source_type, filter_columns, query_key, job_id)
      JSON.parse(lasted_cached_data)
    else
      self.new.perform(source_type, filter_columns, query_key, job_id)
    end
  end
end
