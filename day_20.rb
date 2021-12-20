require 'active_support/all'
require_relative 'enhancement'
require_relative 'image'

File.open("day_20_input.txt") do |file|
# File.open("day_20_input_small.txt") do |file|
  enhancement = nil
  image_grid = []

  file.each_line do |line|
    next if line.blank?

    if enhancement.nil?
      enhancement = Enhancement.from_string(line) 
    else
      image_grid << line.squish.each_char.map { |char| char == "#" ? 1 : 0 }
    end
  end
  image = Image.new(image_grid, 0)

  puts image
  puts image.light_pixels_count

  enhanced_image = image
  2.times do 
    enhanced_image = enhanced_image.enhance(enhancement)
  end

  puts enhanced_image
  puts enhanced_image.light_pixels_count
end
