class FilterBuildingService
  def initialize(column_name, filter_values)
    @column_name = column_name
    @filter_values = filter_values
  end

  def generate_filter
    if column_name.present?
      {
        column: column_name,
        filter_values: filter_values.reduce({}) { |hash, value| hash[value] = true; hash; }
      }
    else
      {}
    end
  end

  def generate_query_key
    return 'full' unless column_name.present?

    value_key = filter_values.sort.reduce('') do |string, value|
      "#{string}_#{value.to_s}"
    end

    "#{column_name}#{value_key}"
  end

  private

  attr_reader :column_name, :filter_values
end
