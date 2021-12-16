require 'active_support/all'
require './line'

File.open("day_8_input.txt") do |file|
# File.open("day_8_input_small.txt") do |file|
  lines = file.each_line.compact_blank.map { |line| Line.new(line.squish.each_char.to_a) }
  puts lines.select(&:corrupted?).sum(&:score)
  incomplete_lines = lines.select(&:incomplete?)
  puts incomplete_lines.map(&:score).sort[incomplete_lines.size / 2]
end
