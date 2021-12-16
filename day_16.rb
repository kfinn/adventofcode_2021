require 'active_support/all'
require './bit_stream.rb'
require './bit_array_bit_stream.rb'
require './packet.rb'
require './literal_value.rb'
require './operator.rb'
require './array.rb'

File.open("day_16_input.txt") do |file|
# File.open("day_16_input_small_literal_value.txt") do |file|
# File.open("day_16_input_small_operator_length_type_0.txt") do |file|
# File.open("day_16_input_small_operator_length_type_1.txt") do |file|
  bit_stream = BitStream.new(file)
  packet = Packet.from_bit_stream(bit_stream)
  puts packet
  puts packet.version_numbers_sum
end
