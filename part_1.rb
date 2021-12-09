require 'active_support/all'
require 'set'
require './line'
require './signal_pattern'

ones_count = 0
fours_count = 0
sevens_count = 0
eights_count = 0

output_values_total = 0

File.open('part_1_input.txt') do |f|
# File.open('simplified_input.txt') do |f|
  f.each_line do |line_string|
    line = Line.from_string(line_string)
    line.output_value.each do |signal_pattern|
      if signal_pattern.one?
        ones_count += 1
      elsif signal_pattern.four?
        fours_count += 1
      elsif signal_pattern.seven?
        sevens_count += 1
      elsif signal_pattern.eight?
        eights_count += 1
      end
    end
    puts "#{line.output_value_values.join('')}: #{line.output_value_value}"
    output_values_total += line.output_value_value
  end
end

puts "ones: #{ones_count}\t fours: #{fours_count}\t sevens: #{sevens_count}\t eights: #{eights_count}"
puts "total count of ones, fours, sevens, and eights: #{[ones_count, fours_count, sevens_count, eights_count].sum}"

puts "total of all output values: #{output_values_total}"
