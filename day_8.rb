require 'active_support/all'
require './line'

File.open("day_8_input.txt") do |file|
# File.open("day_8_input_small.txt") do |file|
  lines = file.each_line.map { |line| Line.new(line.each_char.to_a) }
  puts lines.select(&:corrupted?).sum(&:score)
end
