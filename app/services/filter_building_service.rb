class FilterBuildingService
  class << self
    def generate_filter(column_name, values)
      if column_name.present?
        {
          column: column_name,
          filter_values: values.reduce({}) { |hash, value| hash[value] = true; hash; }
        }
      else
        {}
      end
    end
  end
end
