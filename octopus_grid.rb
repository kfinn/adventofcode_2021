class OctopusGrid
  Position = Struct.new(:row, :column)

  def self.from_file(file)
    new(
      file.each_line.map do |line|
        line.each_char.map(&:presence).compact.map do |char|
          char.to_i
        end
      end
    )
  end

  def initialize(rows)
    @rows = rows
  end

  attr_reader :rows

  def [](position)
    rows[position.row][position.column]
  end

  def []=(position, value)
    rows[position.row][position.column] = value
  end

  def step
    flashing_positions = Set.new
    positions_to_increment = all_positions

    while positions_to_increment.any?
      position = positions_to_increment.pop
      self[position] += 1
      if self[position] > 9 && flashing_positions.exclude?(position)
        flashing_positions << position
        neighboring_positions(position).each do |neighboring_position|
          positions_to_increment << neighboring_position
        end
      end
    end

    flashing_positions.each do |flashing_position|
      self[flashing_position] = 0
    end

    flashing_positions
  end

  def all_positions
    rows.flat_map.with_index do |row, row_index|
      (0...row.size).map do |column_index|
        Position.new(row_index, column_index)
      end
    end
  end

  def neighboring_positions(position)
    unless block_given?
      return to_enum(__method__, position)
    end

    if position.row > 0
      if position.column > 0
        yield Position.new(position.row - 1, position.column - 1)
      end
      yield Position.new(position.row - 1, position.column)
      if position.column < (rows[position.row - 1].size - 1)
        yield Position.new(position.row - 1, position.column + 1)
      end
    end
    if position.column > 0
      yield Position.new(position.row, position.column - 1)
    end
    if position.column < (rows[position.row].size - 1)
      yield Position.new(position.row, position.column + 1)
    end
    if position.row < (rows.size - 1)
      if position.column > 0
        yield Position.new(position.row + 1, position.column - 1)
      end
      yield Position.new(position.row + 1, position.column)
      if position.column < (rows[position.row + 1].size - 1)
        yield Position.new(position.row + 1, position.column + 1)
      end
    end
  end

  def to_s
    row_strings = rows.map { |row| row.join("") }
    row_strings.join("\n")
  end

  def size
    @size ||= rows.map(&:size).sum
  end
end
