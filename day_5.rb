require 'active_support/all'
require './line'

File.open("day_5_input.txt") do |file|
# File.open("day_5_input_small.txt") do |file|
  lines = file.each_line.map do |line_string|
    Line.from_string(line_string)
  end

  map = Hash.new { |hash, key| hash[key] = 0 }
  lines.each do |line|
    line.draw_to(map)
  end

  points_with_two_or_more_lines = map.values.select { |lines_count| lines_count >= 2 }.size
  puts points_with_two_or_more_lines
end
