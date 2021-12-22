class Instruction
  def self.from_string(instruction_string)
    match = instruction_string.match /(on|off) x=(-?\d+)\.\.(-?\d+),y=(-?\d+)\.\.(-?\d+),z=(-?\d+)\.\.(-?\d+)/
    new(
      match[1] == 'on',
      *match[2..7].map(&:to_i)
    )
  end

  def initialize(
    enabled,
    x_min,
    x_max,
    y_min,
    y_max,
    z_min,
    z_max
  )
    @enabled = enabled
    @x_min = x_min
    @x_max = x_max
    @y_min = y_min
    @y_max = y_max
    @z_min = z_min
    @z_max = z_max
  end

  attr_reader :enabled, :x_min, :x_max, :y_min, :y_max, :z_min, :z_max
end
