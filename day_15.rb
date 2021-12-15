require 'active_support/all'
require './cave'
require './cave_position'
require './position'

File.open('day_15_input.txt') do |file|
# File.open('day_15_input_small.txt') do |file|
  cave = Cave.from_file(file)
  puts "safest path total risk: #{cave.safest_path}"
end
