class RelativePosition
  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z
  end

  attr_reader :x, :y, :z

  def +(other)
    RelativePosition.new(x + other.x, y + other.y, z + other.z)
  end

  def -(other)
    RelativePosition.new(x - other.x, y - other.y, z - other.z)
  end

  def <=>(other)
    if x != other.x
      x <=> other.x
    elsif y != other.y
      y <=> other.y
    else
      z <=> other.z
    end
  end

  def facing_positive_x
    self
  end

  def facing_negative_x
    @facing_negative_x ||= RelativePosition.new(
      -x, -y, z
    )
  end

  def facing_positive_y
    @facing_positive_y ||= RelativePosition.new(
      -y, x, z
    )
  end

  def facing_negative_y
    @facing_negative_y ||= RelativePosition.new(
      y, -x, z
    )
  end

  def facing_positive_z
    @facing_positive_z ||= RelativePosition.new(
      -z, y, x
    )
  end
  
  def facing_negative_z
    @facing_negative_z ||= RelativePosition.new(
      z, y, -x
    )
  end

  def rotated_by(orientation)
    case orientation
    when :facing_positive_x_1
      facing_positive_x
    when :facing_positive_x_2
      RelativePosition.new(
          facing_positive_x.x,
          -facing_positive_x.z,
          facing_positive_x.y
        )
      when :facing_positive_x_3
        RelativePosition.new(
          facing_positive_x.x,
          -facing_positive_x.y,
          -facing_positive_x.z
        )
      when :facing_positive_x_4
        RelativePosition.new(
          facing_positive_x.x,
          facing_positive_x.z,
          -facing_positive_x.y
        )
      when :facing_negative_x_1
        facing_negative_x
      when :facing_negative_x_2
        RelativePosition.new(
          facing_negative_x.x,
          -facing_negative_x.z,
          facing_negative_x.y
        )
      when :facing_negative_x_3
        RelativePosition.new(
          facing_negative_x.x,
          -facing_negative_x.y,
          -facing_negative_x.z
        )
      when :facing_negative_x_4
        RelativePosition.new(
          facing_negative_x.x,
          facing_negative_x.z,
          -facing_negative_x.y
        )
      when :facing_positive_y_1
        facing_positive_y
      when :facing_positive_y_2
        RelativePosition.new(
          -facing_positive_y.z,
          facing_positive_y.y,
          facing_positive_y.x
        )
      when :facing_positive_y_3
        RelativePosition.new(
          -facing_positive_y.x,
          facing_positive_y.y,
          -facing_positive_y.z
        )
      when :facing_positive_y_4
        RelativePosition.new(
          facing_positive_y.z,
          facing_positive_y.y,
          -facing_positive_y.x
        )
      when :facing_negative_y_1
        facing_negative_y
      when :facing_negative_y_2
        RelativePosition.new(
          -facing_negative_y.z,
          facing_negative_y.y,
          facing_negative_y.x
        )
      when :facing_negative_y_3
        RelativePosition.new(
          -facing_negative_y.x,
          facing_negative_y.y,
          -facing_negative_y.z
        )
      when :facing_negative_y_4
        RelativePosition.new(
          facing_negative_y.z,
          facing_negative_y.y,
          -facing_negative_y.x
        )
      when :facing_positive_z_1
        facing_positive_z
      when :facing_positive_z_2
        RelativePosition.new(
          -facing_positive_z.y,
          facing_positive_z.x,
          facing_positive_z.z
        )
      when :facing_positive_z_3
        RelativePosition.new(
          -facing_positive_z.x,
          -facing_positive_z.y,
          facing_positive_z.z
        )
      when :facing_positive_z_4
        RelativePosition.new(
          facing_positive_z.y,
          -facing_positive_z.x,
          facing_positive_z.z
        )
      when :facing_negative_z_1
        facing_negative_z
      when :facing_negative_z_2
        RelativePosition.new(
          -facing_negative_z.y,
          facing_negative_z.x,
          facing_negative_z.z
        )
      when :facing_negative_z_3
        RelativePosition.new(
          -facing_negative_z.x,
          -facing_negative_z.y,
          facing_negative_z.z
        )
      when :facing_negative_z_4
        RelativePosition.new(
          facing_negative_z.y,
          -facing_negative_z.x,
          facing_negative_z.z
        )
      else
        raise "invalid orientation: #{orientation}"
    end
  end

  ALL_ORIENTATIONS = 
    [
      :facing_positive_x_1,
      :facing_positive_x_2,
      :facing_positive_x_3,
      :facing_positive_x_4,
      :facing_negative_x_1,
      :facing_negative_x_2,
      :facing_negative_x_3,
      :facing_negative_x_4,
      :facing_positive_y_1,
      :facing_positive_y_2,
      :facing_positive_y_3,
      :facing_positive_y_4,
      :facing_negative_y_1,
      :facing_negative_y_2,
      :facing_negative_y_3,
      :facing_negative_y_4,
      :facing_positive_z_1,
      :facing_positive_z_2,
      :facing_positive_z_3,
      :facing_positive_z_4,
      :facing_negative_z_1,
      :facing_negative_z_2,
      :facing_negative_z_3,
      :facing_negative_z_4
    ]

  def ==(other)
    attributes == other.attributes
  end

  alias eql? ==

  def hash
    attributes.hash
  end


  def attributes
    { x: x, y: y, z: z }
  end

  def to_s
    "#{x},#{y},#{z}"
  end
end
