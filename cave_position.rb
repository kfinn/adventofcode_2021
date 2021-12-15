class CavePosition
  def initialize(risk, position)
    @risk = risk
    @position = position
  end

  attr_reader :risk, :position
  attr_accessor :cave

  def neighbors
    @neighbors ||= neighboring_positions.map { |position| cave[position] }
  end

  def neighboring_positions
    return to_enum(__method__) unless block_given?

    if position.row > 0
      yield Position.new(position.row - 1, position.column)
    end
    if position.column > 0
      yield Position.new(position.row, position.column - 1)
    end
    if position.row < cave.rows.size - 1
      yield Position.new(position.row + 1, position.column)
    end
    if position.column < cave.rows[position.row].size - 1
      yield Position.new(position.row, position.column + 1)
    end
  end
end
