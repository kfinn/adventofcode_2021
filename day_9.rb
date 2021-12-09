require 'active_support/all'
require './map'

sum_of_low_points = 0

File.open('day_9_input.txt') do |file|
# File.open('tiny_day_9_input.txt') do |file|
  map = Map.from_file(file)
  map.local_minima_locations.each do |location|
    location_height = map[location]
    neighboring_locations = map.each_neighboring_location(location).to_a
    neighboring_location_heights = neighboring_locations.map { |neighboring_location| map[neighboring_location] }
    puts "location: #{location} #{location_height} neighboring locations: #{neighboring_locations.join(", ")} neighboring heights: #{neighboring_location_heights.join(", ")}"
      sum_of_low_points += (location_height + 1)
  end
end

puts "sum of low points: #{sum_of_low_points}"
