class Board
  VictoryState = Struct.new(:turn_index, :played_numbers, :last_played_number)

  def initialize(grid, index)
    @grid = grid
    @index = index
  end

  attr_reader :grid, :index
  attr_accessor :game

  def [](row, column)
    grid[row][column]
  end

  def score
    return 0 unless won?

    unplayed_numbers = grid.flatten.select { |number| victory_state.played_numbers.exclude? number }
    unplayed_numbers.sum * victory_state.last_played_number
  end

  def test_for_winning!
    return if won?
    return if win_vectors.none? do |win_vector|
      win_vector.all? do |number|
        game.played? number
      end
    end

    @victory_state = VictoryState.new(
      game.turn_index,
      game.played_numbers.dup,
      game.last_played_number
    )
  end

  attr_reader :victory_state

  def won?
    victory_state.present?
  end

  def win_vectors
    @win_vectors ||= rows + columns
  end

  def rows
    grid
  end

  def columns
    @columns ||=
      (0...grid.first.size).map do |column_index|
        (0...grid.size).map do |row_index|
          grid[row_index][column_index]
        end
      end
  end

  def to_s
    row_strings = rows.map do |row|
      number_strings = row.map do |number|
        if game.played? number
          "*#{number}*"
        else
          number.to_s
        end
      end
      number_strings.join("\t")
    end
    row_strings.join("\n")
  end
end
