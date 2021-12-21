class Player
  def self.from_string(player_string)
    match = player_string.match(/Player (\d+) starting position: (\d+)/)
    index = match[1].to_i
    starting_position = match[2].to_i

    new(index, starting_position)
  end

  def initialize(index, position)
    @index = index
    @position = position
  end

  attr_reader :index
  attr_accessor :position
  attr_writer :score

  def score
    @score ||= 0
  end

  def play!(die)
    rolls = die.roll(3)
    starting_position = self.position
    self.position = ((position + rolls.sum - 1) % 10) + 1
    self.score += position
    puts "player #{index} rolled #{rolls.join(", ")}, moved from #{starting_position} to #{position}, and now has score #{score}"
  end

  def won?
    score >= 1000
  end
end
