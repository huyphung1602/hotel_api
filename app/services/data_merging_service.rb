class DataMergingService
  class << self
    def merge_data_structure(normalizer_class_name, raw_rows)
      normalizer = normalizer_class_name.constantize
      columns_aliases_mapping = normalizer.get_column_aliases_mapping

      raw_rows.reduce({}) do |hash, row|
        current_row_id = normalizer.get_id(row)
        current_row = hash[current_row_id].present? ? hash[current_row_id] : {}

        row.each do |key, value|
          column_name = columns_aliases_mapping[key.underscore.to_sym]

          next if column_name.nil?

          if !current_row[column_name].present?
            current_row[column_name] = value
          end
        end

        hash[current_row_id] = current_row
        hash
      end
    end
  end
end