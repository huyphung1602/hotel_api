class CreateCaches < ActiveRecord::Migration[6.1]
  def change
    create_table :caches do |t|
      t.string :query_key
      t.string :object_type

      t.timestamps
    end
  end
end
