# frozen_string_literal: true

class ChangeDefaultValueStatusToJobs < ActiveRecord::Migration[6.1]
  def change
    change_column :jobs, :status, :integer, default: 3
  end
end
