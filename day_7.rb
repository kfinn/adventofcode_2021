require 'active_support/all'

File.open("day_7_input.txt") do |file|
# File.open("day_7_input_small.txt") do |file|
  starting_crab_positions = file.readline.split(",").map(&:to_i)
  sorted_starting_crab_positions = starting_crab_positions.sort
  
  median = sorted_starting_crab_positions[starting_crab_positions.size / 2]
  mean = starting_crab_positions.sum / starting_crab_positions.size
  
  fuel_cost = lambda do |target|
    starting_crab_positions.sum do |crab_position|
      distance = (target - crab_position).abs
      (distance * (distance + 1)) / 2
    end
  end

  puts "median: #{median - 1}; cost: #{fuel_cost.call(median - 1)}"
  puts "median: #{median}; cost: #{fuel_cost.call(median)}"
  puts "median + 1: #{median + 1}; cost: #{fuel_cost.call(median + 1)}"
  puts "median + 10: #{median + 10}; cost: #{fuel_cost.call(median + 10)}"
  puts "mean: #{mean}; cost: #{fuel_cost.call(mean)}"
end
