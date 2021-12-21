class Game
  TURN_ROLLS_DISTRIBUTION = {
    3 => 1,
    4 => 3,
    5 => 6,
    6 => 7,
    7 => 6,
    8 => 3,
    9 => 1
  }

  Player = Struct.new(:position, :score)
  State = Struct.new(:player_1, :player_2, :next_turn_player)

  def self.from_file(file)
    new(
      *file.each_line.select(&:present?).map do |line|
        match = line.match(/Player \d+ starting position: (\d+)/)
        Player.new(
          match[1].to_i,
          0
        )
      end
    )
  end

  def initialize(initial_player_1, initial_player_2)
    self.state_distribution[State.new(initial_player_1, initial_player_2, :player_1)] = 1
  end

  def state_distribution
    @state_distribution ||= new_state_distribution
  end

  attr_writer :state_distribution

  def new_state_distribution
    Hash.new do |hash, state|
      hash[state] = 0
    end
  end

  def play!
    puts state_distribution
    while state_distribution.any?
      next_state_distribution = new_state_distribution

      state_distribution.each do |state, states_count|
        current_turn_player_symbol = state.next_turn_player
        current_turn_player = current_turn_player_symbol == :player_1 ? state.player_1 : state.player_2
        next_turn_player_symbol = current_turn_player_symbol == :player_1 ? :player_2 : :player_1

        TURN_ROLLS_DISTRIBUTION.each do |roll, rolls_count|
          current_turn_rolls_count = states_count * rolls_count

          current_turn_player_position_after_roll = ((current_turn_player.position + roll - 1) % 10) + 1

          current_turn_player_after_roll = Player.new(
            current_turn_player_position_after_roll,
            current_turn_player.score + current_turn_player_position_after_roll
          )

          if current_turn_player_after_roll.score >= 21
            if current_turn_player_symbol == :player_1
              self.universes_where_player_1_wins += current_turn_rolls_count
            else
              self.universes_where_player_2_wins += current_turn_rolls_count
            end
            next
          end


          state_after_roll = State.new(
            current_turn_player_symbol == :player_1 ? current_turn_player_after_roll : state.player_1,
            current_turn_player_symbol == :player_2 ? current_turn_player_after_roll : state.player_2,
            next_turn_player_symbol
          )

          next_state_distribution[state_after_roll] += current_turn_rolls_count
        end
      end

      puts "completed turn. distinct states: #{next_state_distribution.size}"
      self.state_distribution = next_state_distribution
    end
  end

  def universes_where_player_1_wins
    @universes_where_player_1_wins ||= 0
  end

  def universes_where_player_2_wins
    @universes_where_player_2_wins ||= 0
  end

  attr_writer :universes_where_player_1_wins, :universes_where_player_2_wins
end
