require 'active_support/all'

File.open('day_2_input.txt') do |file|
  horizontal_position = 0
  depth = 0

  file.each_line do |line|
    direction, distance_string = line.split(' ')
    distance = distance_string.to_i
    case direction
    when 'forward'
      horizontal_position += distance
    when 'down'
      depth += distance
    when 'up'
      depth -= distance
    else
      raise "invalid instruction: #{line}"
    end
  end

  puts "horizontal position: #{horizontal_position}\tdepth: #{depth}\tproduct: #{horizontal_position * depth}"
end
