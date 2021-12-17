require 'active_support/all'
require './rectangle'

File.open('day_17_input.txt') do |file|
# File.open('day_17_input_small.txt') do |file|
  target = Rectangle.from_file(file)
  initial_y_velocity = -target.y_min - 1
  puts (initial_y_velocity * (initial_y_velocity + 1)) / 2
end
