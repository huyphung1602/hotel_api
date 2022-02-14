class SourceGatheringWorkerJob
  include Sidekiq::Job

  def perform(source_type, filter, query_key)
    data = ::DataGatheringService.execute(source_type: source_type, filter: filter.symbolize_keys)
    Cache.set_cache(object_type: source_type, query_key: query_key, json_data: data.to_json)
  end
end
