class ColumnSummary
  attr_accessor :count, :ones_count

  def consume!(column_value)
    self.count += 1
    self.ones_count += 1 if column_value.to_i == 1
  end

  def ones_count
    @ones_count ||= 0
  end
  
  def count
    @count ||= 0
  end

  def most_common_value
    ones_count > (count - ones_count) ? 1 : 0
  end

  def least_common_value
    most_common_value == 1 ? 0 : 1
  end
end
