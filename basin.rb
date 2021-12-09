class Basin
  def initialize(minimum_location:, map:)
    @minimum_location = minimum_location
    @map = map
  end

  attr_reader :minimum_location, :map

  delegate :size, to: :locations

  def locations
    unless instance_variable_defined?(:@locations)
      @locations = Set.new
      to_visit = [minimum_location]
      while to_visit.any?
        location = to_visit.pop
        location_height = map[location]
        next if location_height == 9
        next if @locations.include? location
        @locations << location
        map.each_neighboring_location(location) do |neighboring_location|
          to_visit << neighboring_location
        end
      end
    end
    @locations
  end
end
