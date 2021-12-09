class SignalPattern
  def self.from_string(signal_pattern_string)
    signals = signal_pattern_string.each_char.with_object(Set.new) { |signal, set| set << signal }
    new(signals: signals)
  end

  attr_accessor :signals

  def initialize(signals:)
    @signals = signals
  end

  delegate :each, :size, to: :signals

  def one?
    size == 2
  end

  def four?
    size == 4
  end

  def seven?
    size == 3
  end

  def eight?
    size == 7
  end

  def zero_or_six_or_nine?
    size == 6
  end
  
  def two_or_three_or_five?
    size == 5
  end

  def value(line:)  
    if signals == line.one_signal_pattern.signals
      1
    elsif signals == line.two_signal_pattern.signals
      2
    elsif signals == line.three_signal_pattern.signals
      3
    elsif signals == line.four_signal_pattern.signals
      4
    elsif signals == line.five_signal_pattern.signals
      5
    elsif signals == line.six_signal_pattern.signals
      6
    elsif signals == line.seven_signal_pattern.signals
      7
    elsif signals == line.eight_signal_pattern.signals
      8
    elsif signals == line.nine_signal_pattern.signals
      9
    elsif signals == line.zero_signal_pattern.signals
      0
    else
      raise "unknown signal pattern: #{signals} in line: #{line}"
    end
  end
end
