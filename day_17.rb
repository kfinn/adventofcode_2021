require 'active_support/all'
require './rectangle'

Point = Struct.new(:x, :y) do
  def to_s
    "#{x},#{y}"
  end
end

File.open('day_17_input.txt') do |file|
# File.open('day_17_input_small.txt') do |file|
  target = Rectangle.from_file(file)
  min_initial_y_velocity = target.y_min
  max_initial_y_velocity = -target.y_min - 1
  puts (max_initial_y_velocity * (max_initial_y_velocity + 1)) / 2

  global_max_steps_to_target = max_initial_y_velocity * 2 + 2

  min_initial_x_velocity = ((1.0 + Math.sqrt(8.0 * target.x_min.to_f)) / 2.0).floor
  max_initial_x_velocity = target.x_max

  all_initial_velocities = (min_initial_x_velocity..max_initial_x_velocity).flat_map do |initial_x_velocity|
    x = 0
    x_velocity = initial_x_velocity
    min_steps_to_target = nil
    max_discovered_steps_to_target = nil
    current_step = 0
    while x <= target.x_max && x_velocity > 0
      x += x_velocity
      x_velocity = [0, x_velocity - 1].max
      current_step += 1
      if x.in?((target.x_min)..(target.x_max))
        min_steps_to_target ||= current_step
        if x_velocity > 0
          max_discovered_steps_to_target = current_step
        else
          max_discovered_steps_to_target = nil
        end
      end
    end

    max_steps_to_target = max_discovered_steps_to_target || global_max_steps_to_target

    puts "initial_x_velocity: #{initial_x_velocity}, min_steps_to_target: #{min_steps_to_target}, max_steps_to_target: #{max_steps_to_target}"

    if min_steps_to_target.present?
      (min_steps_to_target..max_steps_to_target).flat_map do |steps_to_target|
        (target.y_min..target.y_max).filter_map do |target_y|
          initial_y_velocity_f = (target_y.to_f + ((steps_to_target.to_f * (steps_to_target.to_f - 1.0)) / 2.0)) / steps_to_target.to_f
          initial_y_velocity = initial_y_velocity_f.to_i

          if initial_y_velocity_f == initial_y_velocity
            Point.new(initial_x_velocity, initial_y_velocity_f.to_i)
          else
            nil
          end
        end
      end
    else
      []
    end
  end

  distinct_initial_velocities = all_initial_velocities.uniq
  puts distinct_initial_velocities
  puts distinct_initial_velocities.size
end
