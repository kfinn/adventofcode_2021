require 'active_support/all'
require './map'
require './cave'

File.open('day_12_input.txt') do |f|
# File.open('day_12_input_small.txt') do |f|
# File.open('day_12_input_medium.txt') do |f|
  map = Map.from_file(f)
  paths = map.start_cave.paths_to(map.end_cave)
  paths.each do |path|
    puts path.map(&:name).join(",")
  end
  puts "#{paths.size} paths total"
end
