class ReactorRegion
  def initialize(
    x_min = -Float::INFINITY,
    x_max = Float::INFINITY,
    y_min = -Float::INFINITY,
    y_max = Float::INFINITY,
    z_min = -Float::INFINITY,
    z_max = Float::INFINITY,
    children: nil,
    enabled: false
  )
    @x_min = x_min
    @x_max = x_max
    @y_min = y_min
    @y_max = y_max
    @z_min = z_min
    @z_max = z_max
    @children = children
    @enabled = enabled
  end

  attr_accessor :children
  attr_reader :enabled, :x_min, :x_max, :y_min, :y_max, :z_min, :z_max

  def x_range
    @x_range ||= x_min..x_max
  end

  def y_range
    @y_range ||= y_min..y_max
  end

  def z_range
    @z_range ||= z_min..z_max
  end

  def apply!(instruction)
    return unless (
      x_min <= x_max && ((instruction.x_min)..(instruction.x_max)).overlaps?(x_range) && 
      y_min <= y_max && ((instruction.y_min)..(instruction.y_max)).overlaps?(y_range) && 
      z_min <= z_max && ((instruction.z_min)..(instruction.z_max)).overlaps?(z_range)
    )

    if children.present?
      children.each { |child| child.apply! instruction }
    else
      instruction_child_x_min = [x_min, instruction.x_min].max
      instruction_child_x_max = [x_max, instruction.x_max].min
      instruction_child_y_min = [y_min, instruction.y_min].max
      instruction_child_y_max = [y_max, instruction.y_max].min
      instruction_child_z_min = [z_min, instruction.z_min].max
      instruction_child_z_max = [z_max, instruction.z_max].min

      self.children = [
        ReactorRegion.new(
          x_min,
          instruction_child_x_max,
          y_min,
          instruction_child_y_max,
          z_min,
          instruction_child_z_max,
          children: [
            ReactorRegion.new(
              x_min,
              instruction_child_x_min - 1,
              y_min,
              instruction_child_y_min - 1,
              z_min,
              instruction_child_z_min - 1,
              enabled: enabled
            ),
            ReactorRegion.new(
              instruction_child_x_min,
              instruction_child_x_max,
              y_min,
              instruction_child_y_min - 1,
              z_min,
              instruction_child_z_min - 1,
              enabled: enabled
            ),
            ReactorRegion.new(
              x_min,
              instruction_child_x_min - 1,
              instruction_child_y_min,
              instruction_child_y_max,
              z_min,
              instruction_child_z_min - 1,
              enabled: enabled
            ),
            ReactorRegion.new(
              instruction_child_x_min,
              instruction_child_x_max,
              instruction_child_y_min,
              instruction_child_y_max,
              z_min,
              instruction_child_z_min - 1,
              enabled: enabled
            ),
            ReactorRegion.new(
              x_min,
              instruction_child_x_min - 1,
              y_min,
              instruction_child_y_min - 1,
              instruction_child_z_min,
              instruction_child_z_max,
              enabled: enabled
            ),
            ReactorRegion.new(
              instruction_child_x_min,
              instruction_child_x_max,
              y_min,
              instruction_child_y_min - 1,
              instruction_child_z_min,
              instruction_child_z_max,
              enabled: enabled
            ),
            ReactorRegion.new(
              x_min,
              instruction_child_x_min - 1,
              instruction_child_y_min,
              instruction_child_y_max,
              instruction_child_z_min,
              instruction_child_z_max,
              enabled: enabled
            ),
            ReactorRegion.new(
              instruction_child_x_min,
              instruction_child_x_max,
              instruction_child_y_min,
              instruction_child_y_max,
              instruction_child_z_min,
              instruction_child_z_max,
              enabled: instruction.enabled
            )
          ]
        ),
        ReactorRegion.new(
          instruction_child_x_max + 1,
          x_max,
          y_min,
          instruction_child_y_max,
          z_min,
          instruction_child_z_max,
          enabled: enabled
        ),
        ReactorRegion.new(
          x_min,
          instruction_child_x_max,
          instruction_child_y_max + 1,
          y_max,
          z_min,
          instruction_child_z_max,
          enabled: enabled
        ),
        ReactorRegion.new(
          instruction_child_x_max + 1,
          x_max,
          instruction_child_y_max + 1,
          y_max,
          z_min,
          instruction_child_z_max,
          enabled: enabled
        ),
        ReactorRegion.new(
          x_min,
          instruction_child_x_max,
          y_min,
          instruction_child_y_max,
          instruction_child_z_max + 1,
          z_max,
          enabled: enabled
        ),
        ReactorRegion.new(
          instruction_child_x_max + 1,
          x_max,
          y_min,
          instruction_child_y_max,
          instruction_child_z_max + 1,
          z_max,
          enabled: enabled
        ),
        ReactorRegion.new(
          x_min,
          instruction_child_x_max,
          instruction_child_y_max + 1,
          y_max,
          instruction_child_z_max + 1,
          z_max,
          enabled: enabled
        ),
        ReactorRegion.new(
          instruction_child_x_max + 1,
          x_max,
          instruction_child_y_max + 1,
          y_max,
          instruction_child_z_max + 1,
          z_max,
          enabled: enabled
        ),
      ]
    end
  end

  def enabled_cubes_count
    return children&.map(&:enabled_cubes_count).sum if children.present?
    return 0 unless enabled
    x_range.size * y_range.size * z_range.size
  end
end
