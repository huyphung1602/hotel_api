require 'net/http'
require 'uri'

class DataGatheringService
  def initialize(source_type:, filter:, job_id: nil)
    @source_type = source_type
    @filter = filter
    @job = Job.find_by_id(job_id)
  end

  def execute
    job.start if job.present?

    raw_rows = fetch_data
    merger =  DataSources.get_merger(source_type)
    merged_data_as_hash = raw_rows.reduce({}) do |hash, row|
      if filter.present?
        next hash if filter.present? && !filter[:filter_values][merger.send("get_#{filter[:column]}", row).to_s]
      end

      merging_row_id = merger.get_id(row)

      merging_row = hash[merging_row_id].present? ? hash[merging_row_id] : {}
      merged_row = merger.merge!(merging_row, row)
      hash[merging_row_id] = merged_row
      hash
    end

    job.success if job.present?
    merged_data_as_hash.values

  rescue => e
    job.failed if job.present?
    raise e
  end

  private

  attr_reader :source_type, :filter, :job

  def fetch_data
    sources = DataSources.get_source(source_type)
    sources.reduce([]) do |arr, source|
      uri = URI(source)
      responses = JSON.parse(Net::HTTP.get(uri))

      if responses.is_a?(Array)
        arr += responses
      else
        raise DataGatheringServiceError, "Invalid response data, expecting parsed response as an array: #{responses.inspect}, method: fetch_data"
      end

      arr
    end
  end
end
