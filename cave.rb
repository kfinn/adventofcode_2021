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
    total_risks_by_vertex = { start_vertex => 0 }
    vertices_to_visit = Heap.new do |lhs, rhs|
      total_risks_by_vertex[lhs] < total_risks_by_vertex[rhs]
    end
    vertices_to_visit << start_vertex

    until total_risks_by_vertex.include?(end_vertex)
      current_vertex = vertices_to_visit.pop
      current_total_risk = total_risks_by_vertex[current_vertex]

      current_vertex.edges.each do |edge|
        destination = edge.destination
        current_risk_to_destination = edge.weight + current_total_risk
        existing_risk_to_destination = total_risks_by_vertex[destination]
        if existing_risk_to_destination.blank? || current_risk_to_destination < existing_risk_to_destination
          total_risks_by_vertex[destination] = current_risk_to_destination
          vertices_to_visit << destination if vertices_to_visit.to_a.exclude? destination
        end
      end
    end

    total_risks_by_vertex[end_vertex]
  end
end
