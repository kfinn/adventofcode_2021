class DiagnosticReport
  def self.from_file(file)
    column_summaries = nil

    file.each_line do |line|
      if column_summaries.blank?
        column_summaries = Array.new(line.size - 1) { ColumnSummary.new }
      end
      line.each_char.with_index do |char, index|
        column_summaries[index].consume!(char) unless char.blank?
      end
    end

    new(column_summaries)
  end

  def initialize(column_summaries)
    @column_summaries = column_summaries
  end

  attr_reader :column_summaries

  def gamma_rate
    @gamma_rate ||= column_summaries.reduce(0) do |acc, column_summary|
      (acc * 2) + column_summary.most_common_value
    end
  end

  def epsilon_rate
    @epsilon_rate ||= column_summaries.reduce(0) do |acc, column_summary|
      (acc * 2) + column_summary.least_common_value
    end
  end

  def power_consumption
    gamma_rate * epsilon_rate
  end
end
