class Cave
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def small?
    name.downcase == name
  end

  def neighbors
    @neighbors ||= Set.new
  end

  def add_neighbor(neighbor)
    neighbors << neighbor
  end

  def paths_to(destination, excluding: Set.new)
    return [[self]] if self == destination

    next_excluding = small? ? (excluding | Set.new([self])) : excluding
    visitable_neighbors = neighbors - excluding
    visitable_neighbors.flat_map do |neighbor|
      neighbor
        .paths_to(destination, excluding: next_excluding)
        .map do |neighbor_path|
          [self] + neighbor_path
        end
    end
  end

  def to_s
    name
  end
end
