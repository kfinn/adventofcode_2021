class DeterministicDie
  def roll(n)
    unless instance_variable_defined?(:@next_roll)
      @next_roll = 1
    end

    (0...n).map do |i|
      current_roll = @next_roll

      @next_roll += 1
      @next_roll = 1 if @next_roll > 100
      self.rolls_count += 1

      current_roll
    end
  end

  def rolls_count
    @rolls_count ||= 0
  end

  attr_writer :rolls_count
end
