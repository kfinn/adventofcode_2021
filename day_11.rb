require 'active_support/all'
require './octopus_grid'

File.open('day_11_input.txt') do |file|
# File.open('day_11_input_small.txt') do |file|
  octopus_grid = OctopusGrid.from_file(file)
  flashes = 0
  100.times { flashes += octopus_grid.step.size }
  puts "flashes after 100 steps: #{flashes}"
end
