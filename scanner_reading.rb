class ScannerReading
  def initialize(index, beacon_relative_positions)
    @index = index
    @beacon_relative_positions = beacon_relative_positions
  end

  attr_reader :index, :beacon_relative_positions

  def find_transform_to_match(other)
    RelativePosition::ALL_ORIENTATIONS.each do |orientation|
      rotated_other_beacon_relative_positions = other.beacon_relative_positions.map do |other_beacon_relative_position|
        other_beacon_relative_position.rotated_by(orientation)
      end

      beacon_relative_positions.each do |self_potential_match|
        rotated_other_beacon_relative_positions.each do |other_potential_match|
          self_to_other_space = other_potential_match - self_potential_match
          other_to_self_space = self_potential_match - other_potential_match

          applicable_self_neighbors = beacon_relative_positions.select do |self_potential_match_neighbor|
            offset_from_other = self_potential_match_neighbor + self_to_other_space
            [offset_from_other.x, offset_from_other.y, offset_from_other.z].all? { |coordinate| coordinate.abs <= 1000 }
          end
          next unless applicable_self_neighbors.size >= 12

          applicable_transformed_other_neighbors = rotated_other_beacon_relative_positions.filter_map do |other_potential_match_neighbor|
            offset_from_self = other_potential_match_neighbor + other_to_self_space
            if [offset_from_self.x, offset_from_self.y, offset_from_self.z].all? { |coordinate| coordinate.abs <= 1000 }
              offset_from_self
            end
          end
          next unless applicable_transformed_other_neighbors.size == applicable_self_neighbors.size

          applicable_self_neighbors.sort!
          applicable_transformed_other_neighbors.sort!

          if applicable_self_neighbors == applicable_transformed_other_neighbors
            return Transform.new(
              orientation,
              other_to_self_space
            )
          end
        end
      end
    end
    nil
  end
end
