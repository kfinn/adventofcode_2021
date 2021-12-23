class Situation
  def self.from_file(file)
    space_positions = Set.new
    amphipods = []

    space_characters = Set.new([
      ".",
      "A",
      "B",
      "C",
      "D"
    ])

    file.each_line.with_index do |line, row_index|
      line.each_char.with_index do |char, column_index|
        if char.in? space_characters
          position = Position.new(row_index, column_index)
          space_positions << position
          if char != '.'
            amphipods << Amphipod.new(char, position)
          end
        end
      end
    end

    new(
      space_positions,
      amphipods
    )
  end

  def initialize(space_positions, amphipods)
    @space_positions = space_positions
    self.amphipods = amphipods
  end

  attr_reader :space_positions, :amphipods

  def amphipods=(new_amphipods)
    self.amphipods&.each do |old_amphipod|
      old_amphipod.situation = nil
    end

    @amphipods = new_amphipods

    new_amphipods&.each do |new_amphipod|
      new_amphipod.situation = self
    end
  end

  def hallway_row_index
    @hallway_row_index ||= space_positions.map(&:row).min
  end

  def hallway_column_index_range
    unless instance_variable_defined?(:@hallway_column_index_range)
      column_indexes = space_positions.map(&:column)
      @hallway_column_index_range = (column_indexes.min)..(column_indexes.max)
    end
    @hallway_column_index_range
  end

  def valid_hallway_amphipod_positions
    @valid_hallway_amphipod_positions ||=
      hallway_column_index_range.each_with_object(Set.new) do |column_index, acc|
        acc << Position.new(hallway_row_index, column_index) unless column_index.in?(destination_column_indexes_by_amphipod_type.values)
      end
  end

  def destination_column_for_amphipod_type(amphipod_type)
    destination_column_indexes_by_amphipod_type[amphipod_type]
  end

  def destination_column_indexes_by_amphipod_type
    unless instance_variable_defined?(:@destination_column_indexes_by_amphipod_type)
      non_hallway_positions = space_positions.select { |position| position.row > hallway_row_index }
      non_hallway_columns = non_hallway_positions.map(&:column).uniq.sort
      @destination_column_indexes_by_amphipod_type = {
        "A" => non_hallway_columns[0],
        "B" => non_hallway_columns[1],
        "C" => non_hallway_columns[2],
        "D" => non_hallway_columns[3]
      }
    end
    @destination_column_indexes_by_amphipod_type
  end

  def destination_row_index_range
    @destination_row_index_range ||= space_positions.map(&:row).uniq - [hallway_row_index]
  end

  def position_is_clear?(position)
    position.in?(space_positions) && amphipods.none? { |amphipod| amphipod.position == position }
  end

  def position_is_occupied?(position)
    position.in?(space_positions) && amphipods.any? { |amphipod| amphipod.position == position }
  end

  def completed?
    amphipods.all?(&:at_destination?)
  end

  def ==(other)
    state == other.state
  end

  def hash
    state.hash
  end

  def state
    @state ||= [amphipods.sort]
  end

  def cheapest_path
    total_costs_by_situation = { self => 0 }
    estimated_costs_through_situation = { self => self.estimated_cost_to_destination }
    situations_to_visit = Heap.new do |lhs, rhs|
      estimated_costs_through_situation[lhs] < estimated_costs_through_situation[rhs]
    end
    situations_to_visit_set = Set.new
    situations_to_visit << self
    situations_to_visit_set << self

    counter = 0

    # 100.times do
    while situations_to_visit_set.any?
      current_situation = situations_to_visit.pop
      
      situations_to_visit_set.delete(current_situation)
      current_total_cost_to_situation = total_costs_by_situation[current_situation]
      return current_total_cost_to_situation if current_situation.completed?

      # puts current_situation.to_s
      puts current_situation.to_s if counter % 1024 == 1
      counter = (counter + 1) % 1024

      current_situation.moves.each do |move|
        next_situation = current_situation.apply(move)
        current_risk_to_next_situation = move.cost + current_total_cost_to_situation
        existing_risk_to_next_situation = total_costs_by_situation[next_situation]
        if existing_risk_to_next_situation.blank? || current_risk_to_next_situation < existing_risk_to_next_situation
          total_costs_by_situation[next_situation] = current_risk_to_next_situation
          estimated_costs_through_situation[next_situation] = current_risk_to_next_situation + next_situation.estimated_cost_to_destination
          if situations_to_visit_set.exclude?(next_situation)
            situations_to_visit << next_situation 
            situations_to_visit_set << next_situation
          end
        end
      end
    end
  end

  def moves
    amphipods.flat_map(&:moves)
  end

  def apply(move)
    self.class.new(
      space_positions,
      amphipods.map do |amphipod|
        amphipod.apply(move)
      end
    )
  end

  def to_s
    s = ""

    min_column = hallway_column_index_range.min - 1
    max_column = hallway_column_index_range.max + 1
    min_row = 0
    max_row = destination_row_index_range.max + 1
    (min_row..max_row).each do |row|
      (min_column..max_column).each do |column|
        position = Position.new(row, column)
        if space_positions.exclude?(position)
          s << "#"
        else
          amphipod = amphipods.find { |amphipod| amphipod.position == position }
          if amphipod
            s << amphipod.type
          else
            s << "."
          end
        end
      end
      s << "\n"
    end
    s + "\n"
  end

  def estimated_cost_to_destination
    amphipods.sum(&:estimated_cost_to_destination)
  end
end
