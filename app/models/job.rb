class Job < ApplicationRecord
  validates :source_type, presence: true
  validates :status, presence: true

  enum status: {
    # Note: -1 is used in JobFlow's get_next_jobs so don't use it
    running: 0,
    success: 1,
    failure: 2,
    created: 3,
  }

  def self.set_job(source_id:, source_type:, status: 3)
    Job.create(source_id: source_id, source_type: source_type, status: 3)
  end

  def update_status
    update(status: status)
  end

  def start
    update(start_time: Time.current)
  end

  def end
    update(end_time: Time.current)
  end

  def add_log(message, level = 'info')
    logs = [] if logs.nil?
    logs << "#{level.upcase} --- #{message}"
    update(logs: logs)
  end
  
  def add_logs(messages)
    update(logs: messages)
  end
end
