require 'active_support/all'
require './game'
require './board'

File.open("day_4_input.txt") do |file|
# File.open("day_4_input_small.txt") do |file|
  game = Game.from_file(file)
  winner = game.play!
  puts game
  puts "winner last played number: #{winner.victory_state.last_played_number} winner: #{winner.index} winning score: #{winner.score}"
  loser = game.last_winning_board
  puts "loser last played number: #{loser.victory_state.last_played_number} loser: #{loser.index} winning score: #{loser.score}"
end
