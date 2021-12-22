class Reactor
  Cube = Struct.new(:x, :y, :z)

  def enabled_cubes
    @enabled_cubes ||= Set.new
  end

  def enable!(x, y, z)
    return unless [x, y, z].all? { |coordinate| coordinate.in? -50..50 }
    enabled_cubes << Cube.new(x, y, z)
  end
  
  def disable!(x, y, z)
    return unless [x, y, z].all? { |coordinate| coordinate.in? -50..50 }
    enabled_cubes.delete Cube.new(x, y, z)
  end

  def enabled_cubes_count
    enabled_cubes.size
  end
end
