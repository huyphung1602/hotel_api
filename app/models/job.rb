# frozen_string_literal: true

class Job < ApplicationRecord
  validates :source_type, presence: true
  validates :status, presence: true

  enum status: {
    # NOTE: -1 is used in JobFlow's get_next_jobs so don't use it
    running: 0,
    success: 1,
    failure: 2,
    created: 3,
    already_existed: 4,
  }

  def start
    update(start_time: Time.current, status: 'running')
  end

  def success
    update(end_time: Time.current, status: 'success')
  end

  def fail
    update(end_time: Time.current, status: 'failed')
  end

  def already_existed
    update(end_time: Time.current, status: 'already_existed')
  end

  def self.any_running_job_with_query_key(source_type, query_key)
    where(source_type: source_type, query_key: query_key, status: 'running').any?
  end
end
