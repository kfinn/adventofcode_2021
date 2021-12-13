class DiagnosticReport
  def self.from_file(file)
    lines = []

    file.each_line do |line|
      lines << line.each_char.map(&:presence).compact.map(&:to_i)
    end

    new(lines)
  end

  def initialize(unfiltered_lines, prefix_filter: [])
    @unfiltered_lines = unfiltered_lines
    @prefix_filter = prefix_filter
  end

  attr_reader :unfiltered_lines, :prefix_filter

  def lines
    @lines ||= unfiltered_lines.select do |line|
      line[0...prefix_filter.size] == prefix_filter
    end
  end

  def column_summaries
    @column_summaries ||=
      lines.each_with_object(
        Array.new(lines.first.size) { ColumnSummary.new }
      ) do |line, draft_column_summaries|
        line.each_with_index do |value, index|
          draft_column_summaries[index].consume!(value)
        end
      end
  end

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

  def oxygen_generator_rating
    puts "calculating oxygen generator rating with #{lines.size} filtered lines and prefix #{prefix_filter}"
    @oxygen_generator_rating ||=
      if lines.size == 1
        puts lines.first.join("")
        lines.first.reduce(0) do |acc, value|
          (acc * 2) + value
        end
      else
        active_filter_bit_index = prefix_filter.size
        next_prefix_filter = prefix_filter + [column_summaries[active_filter_bit_index].most_common_value]
        DiagnosticReport.new(unfiltered_lines, prefix_filter: next_prefix_filter).oxygen_generator_rating
      end
  end

  def co2_scrubber_rating
    puts "calculating co2 scrubber rating with #{lines.size} filtered lines and prefix #{prefix_filter}"
    @co2_scrubber_rating ||=
      if lines.size == 1
        puts lines.first.join("")
        lines.first.reduce(0) do |acc, value|
          (acc * 2) + value
        end
      else
        active_filter_bit_index = prefix_filter.size
        next_prefix_filter = prefix_filter + [column_summaries[active_filter_bit_index].least_common_value]
        DiagnosticReport.new(unfiltered_lines, prefix_filter: next_prefix_filter).co2_scrubber_rating
      end
  end

  def life_support_rating
    oxygen_generator_rating * co2_scrubber_rating
  end
end
