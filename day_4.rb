require 'active_support/all'
require './game'
require './board'

File.open("day_4_input.txt") do |file|
# File.open("day_4_input_small.txt") do |file|
  game = Game.from_file(file)
  winner = game.play!
  puts game
  puts "last played number: #{game.last_played_number} winner: #{winner.index} winning score: #{winner.score}"
end
