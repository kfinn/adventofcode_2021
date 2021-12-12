class Cave
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def small?
    name.downcase == name && name != 'start' && name != 'end'
  end

  def large?
    name.upcase == name && name != 'start' && name != 'end'
  end

  def neighbors
    @neighbors ||= Set.new
  end

  def add_neighbor(neighbor)
    neighbors << neighbor
  end

  def paths_to(destination, visit_counts_by_cave: Hash.new { |hash, key| hash[key] = 0 })
    return [[self]] if self == destination

    next_visit_counts_by_cave = visit_counts_by_cave.dup.tap { |vcbc| vcbc[self] += 1 }
    can_revisit_a_small_cave = next_visit_counts_by_cave.none? { |cave, visit_count| cave.small? && visit_count > 1 }
    visitable_neighbors = neighbors.select do |neighbor|
      neighbor.large? || (
        neighbor.small? && (
          can_revisit_a_small_cave || 
          next_visit_counts_by_cave[neighbor] == 0
        )
      ) ||
      neighbor == destination
    end
    visitable_neighbors.flat_map do |neighbor|
      neighbor
        .paths_to(destination, visit_counts_by_cave: next_visit_counts_by_cave)
        .map do |neighbor_path|
          [self] + neighbor_path
        end
    end
  end

  def to_s
    name
  end
end
