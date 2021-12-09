require 'active_support/all'
require './map'
require './basin'

sum_of_low_points = 0

File.open('day_9_input.txt') do |file|
# File.open('tiny_day_9_input.txt') do |file|
  map = Map.from_file(file)
  map.local_minima_locations.each do |location|
    location_height = map[location]
    sum_of_low_points += (location_height + 1)
  end

  map.basins.each do |basin|
    puts "basin: #{basin.minimum_location} size #{basin.size}"
  end

  solution = map.basins.sort_by(&:size).last(3).reduce(1) { |acc, basin| acc * basin.size }
  puts "solution: #{solution}"
end

puts "sum of low points: #{sum_of_low_points}"
