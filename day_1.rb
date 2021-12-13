require 'active_support/all'

File.open('day_1_input.txt') do |f|
# File.open('day_1_small_input.txt') do |f|
  increased_measurements_count = 0
  previous_measurement = nil

  f.each_line do |line|
    measurement = line.to_i
    increased_measurements_count += 1 if previous_measurement.present? && measurement > previous_measurement
    previous_measurement = measurement
  end

  puts "increased measurements: #{increased_measurements_count}"
end
