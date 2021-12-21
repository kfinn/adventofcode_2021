require 'active_support/all'
require_relative 'game'

File.open("day_21_input.txt") do |file|
# File.open("day_21_input_small.txt") do |file|
  game = Game.from_file(file)
  game.play!
  puts "game.universes_where_player_1_wins: #{game.universes_where_player_1_wins}"
  puts "game.universes_where_player_2_wins: #{game.universes_where_player_2_wins}"
end
