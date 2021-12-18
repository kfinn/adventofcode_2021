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

  snailfish_number_pairs = snailfish_numbers.flat_map.with_index do |first_snailfish_number, first_snailfish_number_index|
    snailfish_numbers.slice((first_snailfish_number_index + 1)..).flat_map do |second_snailfish_number|
      [
        [first_snailfish_number, second_snailfish_number],
        [second_snailfish_number, first_snailfish_number]
      ]
    end
  end

  snailfish_number_pair_sums = snailfish_number_pairs.map { |lhs, rhs| lhs + rhs }
  snailfish_number_pair_sum_magnitudes = snailfish_number_pair_sums.map(&:magnitude)
  puts "max magnitude: #{snailfish_number_pair_sum_magnitudes.max}"
end
