class DataMergingService
  class << self
    def merge_data_structure(normalizer_class_name, raw_rows)
      normalizer = normalizer_class_name.constantize

      raw_rows.reduce({}) do |hash, row|
        merging_row_id = normalizer.get_id(row)
        merging_row = hash[merging_row_id].present? ? hash[merging_row_id] : {}
        merged_row = normalizer.merge!(merging_row, row)
        hash[merging_row_id] = merged_row
        hash
      end
    end
  end
end