class Amphipod
  STEP_COSTS_BY_TYPE = {
    "A" => 1,
    "B" => 10,
    "C" => 100,
    "D" => 1000
  }

  Move = Struct.new(:amphipod, :destination, :cost)

  def initialize(type, position, has_moved: false)
    @type = type
    @position = position
    @has_moved = has_moved
  end

  attr_reader :type, :position, :has_moved
  alias has_moved? has_moved
  attr_accessor :situation

  def moves
    return [] if at_destination? && destination_is_clear?

    if has_moved?
      if at_destination?
        []
      elsif destination_is_clear?
        all_final_moves
      else
        []
      end
    else
      all_initial_moves
    end
  end

  def destination_column
    @destination_column ||= situation.destination_column_for_amphipod_type(type)
  end

  def at_destination?
    position.column == situation.destination_column_for_amphipod_type(type) && position.row != situation.hallway_row_index
  end

  def destination_is_clear?
    unless instance_variable_defined?(:@destination_is_clear)
      amphipods_at_destination = situation.amphipods.select { |amphipod| amphipod.position.column == destination_column }
      @destination_is_clear = amphipods_at_destination.all? { |amphipod| amphipod.type == type }
    end
    @destination_is_clear
  end

  def all_initial_moves
    if ((situation.hallway_row_index + 1)..(position.row - 1)).any? { |row| situation.position_is_occupied? Position.new(row, position.column) }
      return [] 
    end
    
    situation
      .valid_hallway_amphipod_positions
      .select do |destination|
        column_extremes = [position.column, destination.column]
        range_covered = (column_extremes.min)..(column_extremes.max)
        range_covered.all? do |column|
          situation.position_is_clear? Position.new(destination.row, column)
        end
      end
      .map do |destination|
        Move.new(
          self,
          destination,
          ((destination.row - position.row).abs + (destination.column - position.column).abs) * step_cost
        )
      end
  end

  def all_final_moves
    destination_column = situation.destination_column_for_amphipod_type(type)
    hallway_columns_to_destination = position.column > destination_column ? (destination_column...(position.column)) : ((position.column + 1)..destination_column)
    if hallway_columns_to_destination.any? { |column| situation.position_is_occupied? Position.new(position.row, column) }
      # puts "early existing for #{type} #{position.row},#{position.column}: no hallway path to destination column along #{hallway_columns_to_destination}"
      return [] 
    end

    destination_row =
      situation
      .destination_row_index_range
      .select { |row| situation.position_is_clear? Position.new(row, destination_column) }
      .max

    return [] unless destination_row.present?

    [
      Move.new(
        self,
        Position.new(destination_row, destination_column),
        ((destination_row - position.row).abs + (destination_column - position.column).abs) * step_cost
      )
    ]
  end

  def step_cost
    STEP_COSTS_BY_TYPE[type]
  end

  def hash
    state.hash
  end

  def ==(other)
    state == other.state
  end

  def state
    [type, position, has_moved]
  end

  def <=>(other)
    state <=> other.state
  end

  def dup
    self.class.new(type, position, has_moved: has_moved)
  end

  def apply(move)
    if self == move.amphipod
      self.class.new(
        type,
        move.destination,
        has_moved: true
      )
    else
      dup
    end
  end

  def estimated_cost_to_destination
    return 0 if at_destination? && destination_is_clear?
    
    (
      (situation.destination_column_for_amphipod_type(type) - position.column).abs +
      (situation.hallway_row_index - position.row).abs +
      (situation.destination_row_index_range.max - situation.hallway_row_index)
    ) * step_cost
  end
end
