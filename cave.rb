class Cave
  def self.from_file(file)
    risks_grid = file.each_line.map.with_index do |line, row_index|
      line.each_char.map(&:presence).compact.map.with_index do |char, column_index|
        char.to_i
      end
    end

    new(risks_grid)
  end

  def initialize(risks_grid)
    @risks_grid = risks_grid
  end

  attr_reader :risks_grid

  def start_vertex
    vertices_by_position[Position.new(0, 0)]
  end

  def end_vertex
    vertices_by_position[Position.new(risks_grid.size - 1, risks_grid.last.size - 1)]
  end

  def vertices_by_position
    @vertices_by_position ||=
      risks_grid
      .each_with_index
      .with_object(
        Hash.new { |hash, position| hash[position] = Vertex.new }
      ) do |(risks_row, row_index), vertices_by_position_builder|
        risks_row.each_with_index do |risk, column_index|
          vertex = vertices_by_position_builder[Position.new(row_index, column_index)]
          vertex.edges =
            [
              row_index > 0 ? Position.new(row_index - 1, column_index) : nil,
              column_index > 0 ? Position.new(row_index, column_index - 1) : nil,
              row_index < risks_grid.size - 1 ? Position.new(row_index + 1, column_index) : nil,
              column_index < risks_row.size - 1 ? Position.new(row_index, column_index + 1) : nil
            ]
            .compact
            .map do |neighbor_position|
              Edge.new(
                vertices_by_position_builder[neighbor_position],
                risks_grid[neighbor_position.row][neighbor_position.column]
              )
            end
      end
    end
  end

  def safest_path
    unvisited_vertices = Set.new(vertices_by_position.values)
    total_risks_by_vertex = { start_vertex => 0 }

    current_vertex = start_vertex
    until total_risks_by_vertex.include?(end_vertex)
      current_total_risk = total_risks_by_vertex[current_vertex]
      current_edges_to_traverse = current_vertex.edges.select do |edge|
        unvisited_vertices.include? edge.destination
      end
      current_edges_to_traverse.each do |edge|
        total_risk_to_destination = [edge.weight + current_total_risk, total_risks_by_vertex[edge.destination]].compact.min
        total_risks_by_vertex[edge.destination] = total_risk_to_destination
      end
      unvisited_vertices.delete(current_vertex)

      reachable_unvisited_vertices = unvisited_vertices.select do |unvisited_vertex|
        total_risks_by_vertex.include? unvisited_vertex
      end
      current_vertex = reachable_unvisited_vertices.min_by do |reachable_vertex|
        total_risks_by_vertex[reachable_vertex]
      end
    end

    total_risks_by_vertex[end_vertex]
  end
end
