class RemoveLogsFromJobs < ActiveRecord::Migration[6.1]
  def change
    remove_column :jobs, :logs
  end
end
