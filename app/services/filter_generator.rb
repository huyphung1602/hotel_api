class FilterGenerator
  def self.generate_filters(filter_columns)
    filter_columns.map do |column_name, filter_values|
      {
        column_name: column_name,
        filter_values: filter_values.each_with_object({}) { |v, h| h[v] = true },
      }
    end
  end
end
