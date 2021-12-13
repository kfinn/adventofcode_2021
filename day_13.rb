require 'active_support/all'
require './page'
require './dot'
require './fold'

File.open('day_13_input.txt') do |file|
# File.open('day_13_small_input.txt') do |file|
  page = Page.from_file(file)
  puts page.input_dots.size
  puts page.folded_dots.size
  puts page.folds.size
end
