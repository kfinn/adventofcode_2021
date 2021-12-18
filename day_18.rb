require 'active_support/all'
require './snailfish_number'
require './regular_number'

File.open('day_18_input.txt') do |file|
# File.open('day_18_input_small.txt') do |file|
  snailfish_numbers = file.each_line.map { |line| SnailfishNumber.from_io(StringIO.new(line)) }
  puts snailfish_numbers.map(&:to_s).join("\n")
  sum = snailfish_numbers.slice(1..).reduce(snailfish_numbers.first) do |acc, snailfish_number|
    acc + snailfish_number
  end

  puts sum

  puts sum.magnitude
end
