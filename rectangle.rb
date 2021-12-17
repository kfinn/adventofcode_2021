class Rectangle
  def self.from_file(file)
    match = file.readline.match /target area: x=(-?\d+)\.\.(-?\d+), y=(-?\d+)\.\.(-?\d+)/
    new(match[1].to_i, match[2].to_i, match[3].to_i, match[4].to_i)
  end

  def initialize(x_min, x_max, y_min, y_max)
    @x_min = x_min
    @x_max = x_max
    @y_min = y_min
    @y_max = y_max
  end

  attr_reader :x_min, :x_max, :y_min, :y_max
end
