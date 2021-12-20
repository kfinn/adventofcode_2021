class Image
  Position = Struct.new(:row, :column) do
    def each_neighbor
      return to_enum(__method__) unless block_given?

      yield self.class.new(row - 1, column - 1)
      yield self.class.new(row - 1, column)
      yield self.class.new(row - 1, column + 1)
      yield self.class.new(row, column - 1)
      yield self.class.new(row, column)
      yield self.class.new(row, column + 1)
      yield self.class.new(row + 1, column - 1)
      yield self.class.new(row + 1, column)
      yield self.class.new(row + 1, column + 1)
    end
  end

  def initialize(grid, background)
    @grid = grid
    @background = background
  end

  attr_reader :grid, :background

  def [](position)
    if position.row >= 0 && position.row < grid.size
      row = grid[position.row]
      if position.column >= 0 && position.column < row.size
        return row[position.column]
      end
    end

    background
  end

  def enhance(enhancement)
    enhanced_grid = Array.new(grid.size + 2) do |enhanced_row_index|
      Array.new(grid.first.size + 2)
    end

    ((-1)..(grid.size)).each do |row_index|
      enhanced_row_index = row_index + 1
      ((-1)..(grid.first.size)).each do |column_index|
        enhanced_column_index = column_index + 1

        position = Position.new(row_index, column_index)
        enhanced_value = enhancement.enhance(
          position.each_neighbor.map { |neighbor| self[neighbor] }
        )

        enhanced_grid[enhanced_row_index][enhanced_column_index] = enhanced_value
      end
    end

    enhanced_background = enhancement.enhance(Array.new(9, background))

    self.class.new(
      enhanced_grid,
      enhanced_background
    )
  end

  def light_pixels_count
    raise "infinite pixels lit" if background != 0
    grid.sum(&:sum)
  end
  
  def to_s
    lines = grid.map do |row|
      row.map { |value| value == 1 ? "#" : "." }.join
    end
    lines.join("\n")
  end
end
