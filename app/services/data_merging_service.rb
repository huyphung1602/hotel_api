class DataMergingService
  class << self
    def merge_data_structure(merger, raw_rows, filter = {})
      raw_rows.reduce({}) do |hash, row|
        if filter.present?
          next hash if filter.present? && !filter[:filter_values][merger.send("get_#{filter[:column]}", row).to_s]
        end

        merging_row_id = merger.get_id(row)

        merging_row = hash[merging_row_id].present? ? hash[merging_row_id] : {}
        merged_row = merger.merge!(merging_row, row)
        hash[merging_row_id] = merged_row
        hash
      end
    end
  end
end
