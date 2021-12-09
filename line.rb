class Line
  def self.from_string(line_string)
    segments = line_string.split('|')
    raise "invalid line: #{line_string}" unless segments.size == 2
    new(
      all_signal_patterns: segments.first.split(" ").map { |signal_pattern_string| SignalPattern.from_string(signal_pattern_string) },
      output_value: segments.last.split(" ").map { |signal_pattern_string| SignalPattern.from_string(signal_pattern_string) }
    )
  end

  attr_accessor :all_signal_patterns
  attr_accessor :output_value

  def initialize(all_signal_patterns:, output_value:)
    @all_signal_patterns = all_signal_patterns
    @output_value = output_value
  end

  def output_value_value
    result = 0
    output_value_values.each_with_index do |value, index|
      result += value * (10 ** (3 - index))
    end
    result
  end

  def output_value_values
    @output_value_values ||= output_value.map { |signal_pattern| signal_pattern.value(line: self) }
  end

  def one_signal_pattern
    @one_signal_pattern ||= all_signal_patterns.find(&:one?)
  end

  def four_signal_pattern
    @four_signal_pattern ||= all_signal_patterns.find(&:four?)
  end

  def seven_signal_pattern
    @seven_signal_pattern ||= all_signal_patterns.find(&:seven?)
  end

  def eight_signal_pattern
    @eight_signal_pattern ||= all_signal_patterns.find(&:eight?)
  end

  def nine_signal_pattern
    @nine_signal_pattern ||= zero_and_six_and_nine_signal_patterns.find do |signal_pattern|
      four_signal_pattern.signals & signal_pattern.signals == four_signal_pattern.signals
    end
  end

  def zero_signal_pattern
    @zero_signal_pattern ||= (zero_and_six_and_nine_signal_patterns - [nine_signal_pattern]).find do |signal_pattern|
      seven_signal_pattern.signals & signal_pattern.signals == seven_signal_pattern.signals
    end
  end

  def six_signal_pattern
    @six_signal_pattern ||= (zero_and_six_and_nine_signal_patterns - [nine_signal_pattern, zero_signal_pattern]).first
  end

  def zero_and_six_and_nine_signal_patterns
    @zero_and_six_and_nine_signal_patterns ||= all_signal_patterns.select(&:zero_or_six_or_nine?)
  end

  def two_signal_pattern
    @two_signal_pattern ||= (two_and_three_and_five_signal_patterns - [five_signal_pattern, three_signal_pattern]).first
  end

  def five_signal_pattern
    @five_signal_pattern ||= two_and_three_and_five_signal_patterns.find do |signal_pattern|
      signal_pattern.signals & six_signal_pattern.signals == signal_pattern.signals
    end
  end

  def three_signal_pattern
    @three_signal_pattern ||= two_and_three_and_five_signal_patterns.find do |signal_pattern|
      signal_pattern.signals & one_signal_pattern.signals == one_signal_pattern.signals
    end
  end

  def two_and_three_and_five_signal_patterns
    @two_and_three_and_five_signal_patterns ||= all_signal_patterns.select(&:two_or_three_or_five?)
  end
end
