require 'active_support/all'
require_relative 'instruction'
require_relative 'reactor_region'

File.open("day_22_input.txt") do |file|
# File.open("day_22_input_small.txt") do |file|
# File.open("day_22_input_medium.txt") do |file|
  instructions = file.each_line.select(&:present?).map { |line| Instruction.from_string(line) }

  reactor = ReactorRegion.new

  instructions.each do |instruction|
    reactor.apply! instruction
  end

  puts reactor.enabled_cubes_count
end
