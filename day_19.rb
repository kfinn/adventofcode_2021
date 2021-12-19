require 'active_support/all'
require_relative 'scanner_reading'
require_relative 'relative_position'
require_relative 'transform'

ScannerReadingRelationship = Struct.new(:scanner_reading, :transform)

File.open('day_19_input.txt') do |file|
# File.open('day_19_input_small.txt') do |file|
  scanner_readings = []

  current_scanner_reading_index = nil
  current_scanner_reading_beacon_relative_positions = []

  file.each_line do |line|
    if current_scanner_reading_index.nil?
      current_scanner_reading_index = line.match(/--- scanner (\d+) ---/)[1].to_i
    elsif line.present?
      current_scanner_reading_beacon_relative_positions << RelativePosition.new(*line.split(",").map(&:to_i))
    else
      scanner_readings << ScannerReading.new(current_scanner_reading_index, current_scanner_reading_beacon_relative_positions)
      current_scanner_reading_index = nil
      current_scanner_reading_beacon_relative_positions = []
    end
  end
  scanner_readings << ScannerReading.new(current_scanner_reading_index, current_scanner_reading_beacon_relative_positions)

  absolute_scanner_reading = scanner_readings.first
  relative_scanner_readings = scanner_readings[1..]

  scanner_reading_transforms_to_absolute = {}
  while (relative_scanner_readings - scanner_reading_transforms_to_absolute.keys).any?
    (relative_scanner_readings - scanner_reading_transforms_to_absolute.keys).each do |unmatched_scanner_reading|
      scanner_readings.each do |matched_scanner_reading|
        next if unmatched_scanner_reading == matched_scanner_reading
        next if matched_scanner_reading != absolute_scanner_reading && scanner_reading_transforms_to_absolute.exclude?(matched_scanner_reading)

        transform = matched_scanner_reading.find_transform_to_match(unmatched_scanner_reading)
        next unless transform.present?
        puts "#{unmatched_scanner_reading.index} -> #{matched_scanner_reading.index}, #{transform}"
        if matched_scanner_reading == absolute_scanner_reading
          scanner_reading_transforms_to_absolute[unmatched_scanner_reading] = transform
        else
          scanner_reading_transforms_to_absolute[unmatched_scanner_reading] =
            (scanner_reading_transforms_to_absolute[matched_scanner_reading] + transform)
        end
      end
    end
  end

  all_absolute_beacon_readings = Set.new
  absolute_scanner_reading.beacon_relative_positions.each do |beacon_relative_position|
    all_absolute_beacon_readings << beacon_relative_position
  end
  relative_scanner_readings.each do |relative_scanner_reading|
    relative_scanner_reading.beacon_relative_positions.each do |beacon_relative_position|
      beacon_absolute_position = scanner_reading_transforms_to_absolute[relative_scanner_reading].apply(beacon_relative_position)
      all_absolute_beacon_readings << beacon_absolute_position
    end
  end
  puts all_absolute_beacon_readings.map(&:to_s)
  puts all_absolute_beacon_readings.size
end
