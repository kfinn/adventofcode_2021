class Instruction
  def self.from_string(instruction_string)
    match = instruction_string.match /(on|off) x=(-?\d+)\.\.(-?\d+),y=(-?\d+)\.\.(-?\d+),z=(-?\d+)\.\.(-?\d+)/
    new(
      match[1] == 'on',
      *match[2..7].map(&:to_i)
    )
  end

  def initialize(
    power_state,
    input_x_min,
    input_x_max,
    input_y_min,
    input_y_max,
    input_z_min,
    input_z_max
  )
    @power_state = power_state
    @input_x_min = input_x_min
    @input_x_max = input_x_max
    @input_y_min = input_y_min
    @input_y_max = input_y_max
    @input_z_min = input_z_min
    @input_z_max = input_z_max
  end

  attr_reader :power_state, :input_x_min, :input_x_max, :input_y_min, :input_y_max, :input_z_min, :input_z_max

  def x_min
    @x_min ||= [[input_x_min, 51].min, -50].max
  end

  def y_min
    @y_min ||= [[input_y_min, 51].min, -50].max
  end

  def z_min
    @z_min ||= [[input_z_min, 51].min, -50].max
  end

  def x_max
    @x_max ||= [[input_x_max, -51].max, 50].min
  end

  def y_max
    @y_max ||= [[input_y_max, -51].max, 50].min
  end

  def z_max
    @z_max ||= [[input_z_max, -51].max, 50].min
  end

  def apply!(reactor)
    if power_state
      each_coordinate do |x, y, z|
        reactor.enable! x, y, z
      end
    else
      each_coordinate do |x, y, z|
        reactor.disable!(x, y, z)
      end
    end
  end

  def each_coordinate
    (x_min..x_max).each do |x|
      (y_min..y_max).each do |y|
        (z_min..z_max).each do |z|
          yield x, y, z
        end
      end
    end
  end
end
