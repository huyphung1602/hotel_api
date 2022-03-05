class DataFilter
  def initialize(source_type, filter_columns, rows)
    @rows = rows
    @filters = build_filter(filter_columns)
    @data_source = DataSource.get_source(source_type)
  end

  def execute
    rows.map { |row| row if is_matched_row? }.compact
  end

  private

  attr_reader :filters, :data_source, :rows

  def is_matched_row?
    filters.each do |filter|
      return true unless filter[:filter_values][data_source.send("get_#{filter[:column_name]}", row).to_s]
    end
  end

  def build_filter(filter_columns)
    filter_columns.map do |column_name, filter_values|
      {
        column_name: column_name,
        filter_values: filter_values.each_with_object({}) { |v, h| h[v] = true },
      }
    end
  end
end
