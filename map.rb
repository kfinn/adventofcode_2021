class Map
  Location = Struct.new(:row, :column) do
    def to_s
      "[#{row} #{column}]"
    end
  end

  def self.from_file(file)
    heights = []
    file.each_line do |file_line|
      row = []
      file_line.each_char do |file_char|
        next if file_char == "\n"
        row << file_char.to_i
      end
      heights << row
    end
    puts heights.size
    puts heights.first.size
    puts heights.first.join(",")
    new(heights)
  end

  def initialize(heights)
    @heights = heights
  end

  attr_reader :heights

  def local_minima_locations
    @local_minima_locations = each_location.select do |location|
      each_neighboring_location(location).all? do |neighboring_location|
        self[location] < self[neighboring_location]
      end
    end
  end

  def each_location
    unless block_given?
      return to_enum(__method__) do
        rows_count * columns_count
      end
    end

    heights.each_with_index do |heights_row, row|
      heights_row.each_with_index do |height, column|
        yield Location.new(row, column)
      end
    end
  end

  def each_neighboring_location(location)
    unless block_given?
      return to_enum(__method__, location)
    end

    if location.row > 0
      yield Location.new(location.row - 1, location.column)
    end
    if location.row < rows_count - 1
      yield Location.new(location.row + 1, location.column)
    end
    if location.column > 0
      yield Location.new(location.row, location.column - 1)
    end
    if location.column < columns_count - 1
      yield Location.new(location.row, location.column + 1)
    end
  end

  def rows_count
    heights.size
  end

  def columns_count
    heights.first.size
  end

  def [](location)
    heights[location.row][location.column]
  end

  def basins
    @basins = local_minima_locations.map { |local_minimum_location| Basin.new(minimum_location: local_minimum_location, map: self) }
  end
end
