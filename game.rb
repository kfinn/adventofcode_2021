class Game
  def self.from_file(file)
    random_seed = nil
    board_grids = []
    current_board_grid = []

    file.each_line do |line|
      if random_seed.blank?
        random_seed = line.split(",").map(&:presence).compact.map(&:to_i) 
        next
      end

      if line.blank?
        board_grids << current_board_grid if current_board_grid.any?
        current_board_grid = []
        next
      end

      current_board_grid << line.split.map(&:to_i)
    end
    board_grids << current_board_grid if current_board_grid.any?

    boards = board_grids.map.with_index { |board_grid, index| Board.new(board_grid, index) }

    new(random_seed, boards)
  end

  def initialize(random_seed, boards)
    @random_seed = random_seed
    @boards = boards

    boards.each do |board|
      board.game = self
    end
  end

  attr_reader :random_seed, :boards, :last_played_number

  def play!
    while boards.none?(&:won?)
      played_numbers << (@last_played_number = random_seed.shift)
    end

    boards.find(&:won?)
  end

  def played_numbers
    @played_numbers ||= Set.new
  end

  def played?(number)
    played_numbers.include? number
  end

  def unplayed?(number)
    played_numbers.exclude? number
  end

  def to_s
    <<~TXT
      #{played_numbers.join(", ")}
      #{last_played_number}
      #{random_seed}

      #{boards.map(&:to_s).join("\n\n")}
    TXT
  end
end
