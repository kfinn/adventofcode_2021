class Dot
  def self.from_string(dot_string)
    coordinates = dot_string.split(",")
    new(coordinates.first.to_i, coordinates.second.to_i)
  end

  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  delegate :hash, to: :attributes

  def ==(other)
    other.kind_of?(self.class) && attributes == other.attributes
  end

  def eql?(other)
    self == other
  end

  def attributes
    { x: x, y: y }
  end
end
