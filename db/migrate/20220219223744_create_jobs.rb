# frozen_string_literal: true

class CreateJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :jobs do |t|
      t.integer :source_id
      t.string :source_type
      t.datetime :start_time
      t.datetime :end_time
      t.column :status, :integer, default: 0
      t.jsonb :logs

      t.timestamps
    end
  end
end
