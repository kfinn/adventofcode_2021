require 'active_support/all'
require_relative 'deterministic_die'
require_relative 'player'

File.open("day_21_input.txt") do |file|
# File.open("day_21_input_small.txt") do |file|
  players = file.each_line.filter_map do |line|
    puts line
    next if line.blank?

    puts 'making a player'
    Player.from_string(line)
  end

  die = DeterministicDie.new
  current_player_index = 0
  while players.none?(&:won?)
    players[current_player_index].play!(die)
    current_player_index = (current_player_index + 1) % players.size
  end

  puts players.reject(&:won?).first.score
  puts die.rolls_count
  puts players.reject(&:won?).first.score * die.rolls_count
end
