require 'active_support/all'
require './page'
require './dot'
require './fold'

File.open('day_13_input.txt') do |file|
# File.open('day_13_small_input.txt') do |file|
  page = Page.from_file(file)

  (0..page.folded_dots_max_y).each do |y|
    (0..page.folded_dots_max_x).each do |x|
      if page.folded_dots.include? Dot.new(x, y)
        print "#"
      else
        print " "
      end
    end
    print "\n"
  end
end
