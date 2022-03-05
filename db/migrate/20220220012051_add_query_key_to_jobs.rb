# frozen_string_literal: true

class AddQueryKeyToJobs < ActiveRecord::Migration[6.1]
  def change
    add_column :jobs, :query_key, :string
  end
end
