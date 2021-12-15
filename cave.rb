class Cave
  def self.from_file(file)
    rows = file.each_line.map.with_index do |line, row_index|
      line.each_char.map(&:presence).compact.map.with_index do |char, column_index|
        CavePosition.new(char.to_i, Position.new(row_index, column_index))
      end
    end

    new(rows)
  end

  def initialize(rows)
    @rows = rows

    rows.each do |row|
      row.each do |cave_position|
        cave_position.cave = self
      end
    end
  end

  attr_reader :rows

  def [](position)
    rows[position.row][position.column]
  end

  def start_cave_position
    @start_cave_position ||= rows.first.first
  end

  def end_cave_position
    @end_cave_position ||= rows.last.last
  end

  def safest_path
    unvisited_cave_positions = rows.flatten
    total_risks_by_position = {}
    total_risks_by_position[start_cave_position.position] = 0

    current_cave_position = start_cave_position
    until total_risks_by_position.include?(end_cave_position.position)
      current_total_risk = total_risks_by_position[current_cave_position.position]
      current_neighbors_to_visit = current_cave_position.neighbors & unvisited_cave_positions
      current_neighbors_to_visit.each do |neighbor|
        total_risk_to_neighbor = [neighbor.risk + current_total_risk, total_risks_by_position[neighbor.position]].compact.min
        total_risks_by_position[neighbor.position] = total_risk_to_neighbor
      end
      unvisited_cave_positions.delete(current_cave_position)

      reachable_unvisited_cave_positions = unvisited_cave_positions.select do |unvisited_cave_position|
        total_risks_by_position.include? unvisited_cave_position.position
      end
      current_cave_position = reachable_unvisited_cave_positions.min_by do |reachable_unvisited_cave_position|
        total_risks_by_position[reachable_unvisited_cave_position.position]
      end
    end

    total_risks_by_position[end_cave_position.position]
  end
end
