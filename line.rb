class Line
  Point = Struct.new(:x, :y) do
    def self.from_string(point_string)
      coordinates = point_string.split(",")
      new coordinates.first.to_i, coordinates.last.to_i
    end
  end
  
  def self.from_string(line_string)
    point_strings = line_string.split(" -> ")
    start_point = Point.from_string point_strings.first
    end_point = Point.from_string point_strings.last

    new(start_point, end_point)
  end

  def initialize(start_point, end_point)
    @start_point = start_point
    @end_point = end_point
  end

  attr_reader :start_point, :end_point

  def draw_to(map)
    return if start_point.x != end_point.x && start_point.y != end_point.y

    if start_point.x == end_point.x
      y_values = [start_point.y, end_point.y]
      min_y = y_values.min
      max_y = y_values.max

      (min_y..max_y).each do |y|
        map[Point.new(start_point.x, y)] += 1
      end
    else
      x_values = [start_point.x, end_point.x]
      min_x = x_values.min
      max_x = x_values.max

      (min_x..max_x).each do |x|
        map[Point.new(x, start_point.y)] += 1
      end
    end
  end
end
