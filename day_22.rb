require 'active_support/all'
require_relative 'instruction'
require_relative 'reactor'

File.open("day_22_input.txt") do |file|
# File.open("day_22_input_small.txt") do |file|
  instructions = file.each_line.select(&:present?).map { |line| Instruction.from_string(line) }

  reactor = Reactor.new

  instructions.each do |instruction|
    instruction.apply! reactor
  end

  puts reactor.enabled_cubes_count
end
