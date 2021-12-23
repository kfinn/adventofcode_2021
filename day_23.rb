require 'active_support/all'
require 'rb_heap'
require_relative 'situation'
require_relative 'position'
require_relative 'amphipod'

File.open("day_23_input.txt") do |file|
# File.open("day_23_input_small.txt") do |file|
  situation = Situation.from_file(file)
  puts situation.cheapest_path
end
